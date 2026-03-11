#!/usr/bin/env ruby
require "yaml"

def abort_usage(message)
  warn(message)
  exit(1)
end

MKDOCS_FILE = ARGV.shift or abort_usage("Usage: helpme_nav.rb <mkdocs.yml> <command> [...]")
COMMAND = ARGV.shift or abort_usage("Usage: helpme_nav.rb <mkdocs.yml> <command> [...]")

def load_config(path)
  data = YAML.load_file(path) || {}
  data["nav"] ||= []
  data
end

def save_config(path, data)
  File.write(path, data.to_yaml(line_width: -1))
end

def infer_group_dir(children)
  overview = children.find do |item|
    value = item.values.first
    value.is_a?(String) && File.basename(value) == "index.md"
  end
  if overview
    return File.dirname(overview.values.first)
  end

  page_dirs = children.filter_map do |item|
    value = item.values.first
    value.is_a?(String) ? File.dirname(value) : nil
  end.uniq.reject { |dir| dir == "." }

  return page_dirs.first if page_dirs.length == 1

  ""
end

def walk(nodes, parent_id = "root", records = [])
  nodes.each_with_index do |item, idx|
    title = item.keys.first
    value = item.values.first
    id = parent_id == "root" ? (idx + 1).to_s : "#{parent_id}.#{idx + 1}"

    if value.is_a?(Array)
      records << [id, parent_id, "group", title, "", infer_group_dir(value)]
      walk(value, id, records)
    else
      records << [id, parent_id, "page", title, value, File.dirname(value)]
    end
  end
  records
end

def locate(nodes, target_id, parent_id = "root")
  nodes.each_with_index do |item, idx|
    title = item.keys.first
    value = item.values.first
    current_id = parent_id == "root" ? (idx + 1).to_s : "#{parent_id}.#{idx + 1}"

    return [nodes, idx, item, current_id, parent_id] if current_id == target_id

    if value.is_a?(Array)
      found = locate(value, target_id, current_id)
      return found if found
    end
  end
  nil
end

def child_array(nav, parent_id)
  return nav if parent_id == "root"

  found = locate(nav, parent_id)
  abort_usage("Unknown parent id: #{parent_id}") unless found

  item = found[2]
  value = item.values.first
  abort_usage("Target parent is not a group: #{parent_id}") unless value.is_a?(Array)

  value
end

config = load_config(MKDOCS_FILE)
nav = config["nav"]

case COMMAND
when "dump"
  walk(nav).each do |row|
    puts row.join("\t")
  end

when "meta"
  puts ["site_url", config["site_url"].to_s].join("\t")

when "rename"
  target_id = ARGV.shift or abort_usage("rename requires: <id> <new-title>")
  new_title = ARGV.shift or abort_usage("rename requires: <id> <new-title>")
  found = locate(nav, target_id) or abort_usage("Unknown id: #{target_id}")
  value = found[2].values.first
  found[0][found[1]] = { new_title => value }
  save_config(MKDOCS_FILE, config)

when "delete"
  target_id = ARGV.shift or abort_usage("delete requires: <id>")
  found = locate(nav, target_id) or abort_usage("Unknown id: #{target_id}")
  found[0].delete_at(found[1])
  save_config(MKDOCS_FILE, config)

when "add-page"
  parent_id = ARGV.shift or abort_usage("add-page requires: <parent-id> <title> <relpath>")
  title = ARGV.shift or abort_usage("add-page requires: <parent-id> <title> <relpath>")
  relpath = ARGV.shift or abort_usage("add-page requires: <parent-id> <title> <relpath>")
  child_array(nav, parent_id) << { title => relpath }
  save_config(MKDOCS_FILE, config)

when "add-group"
  parent_id = ARGV.shift or abort_usage("add-group requires: <parent-id> <title> <index-relpath>")
  title = ARGV.shift or abort_usage("add-group requires: <parent-id> <title> <index-relpath>")
  index_relpath = ARGV.shift or abort_usage("add-group requires: <parent-id> <title> <index-relpath>")
  child_array(nav, parent_id) << { title => [{ "Overview" => index_relpath }] }
  save_config(MKDOCS_FILE, config)

when "set-page"
  target_id = ARGV.shift or abort_usage("set-page requires: <id> <title> <relpath>")
  title = ARGV.shift or abort_usage("set-page requires: <id> <title> <relpath>")
  relpath = ARGV.shift or abort_usage("set-page requires: <id> <title> <relpath>")
  found = locate(nav, target_id) or abort_usage("Unknown id: #{target_id}")
  value = found[2].values.first
  abort_usage("Target is not a page: #{target_id}") unless value.is_a?(String)
  found[0][found[1]] = { title => relpath }
  save_config(MKDOCS_FILE, config)

when "move-item"
  target_id = ARGV.shift or abort_usage("move-item requires: <id> <new-parent-id>")
  new_parent_id = ARGV.shift or abort_usage("move-item requires: <id> <new-parent-id>")
  found = locate(nav, target_id) or abort_usage("Unknown id: #{target_id}")
  item = found[0].delete_at(found[1])
  child_array(nav, new_parent_id) << item
  save_config(MKDOCS_FILE, config)

else
  abort_usage("Unknown command: #{COMMAND}")
end
