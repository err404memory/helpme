#!/usr/bin/env python3
import os
import shutil
import tempfile
from urllib.parse import urlsplit

from mkdocs.commands.build import build
from mkdocs.config import load_config
from mkdocs.livereload import LiveReloadServer


CONFIG_FILE = os.environ.get("MKDOCS_CONFIG_FILE", "/docs/mkdocs.yml")
DEV_ADDR = os.environ.get("MKDOCS_DEV_ADDR", "0.0.0.0:8000")
WATCH_PATHS = [
    item
    for item in os.environ.get("MKDOCS_WATCH", "/docs/docs:/docs/mkdocs.yml").split(":")
    if item
]


def get_config(site_dir: str):
    cfg = load_config(config_file=CONFIG_FILE, site_dir=site_dir, dev_addr=DEV_ADDR)
    for item in WATCH_PATHS:
        if item not in cfg.watch:
            cfg.watch.append(item)
    return cfg


def main() -> int:
    site_dir = tempfile.mkdtemp(prefix="mkdocs_live_")
    config = get_config(site_dir)
    config.plugins.on_startup(command="serve", dirty=False)

    host, port = config.dev_addr
    mount_path = urlsplit(config.site_url or "/").path or "/"
    config.site_url = serve_url = f"http://{host}:{port}{mount_path if mount_path.startswith('/') else '/' + mount_path}"

    def builder(current_config=None):
        cfg = current_config or get_config(site_dir)
        cfg.site_url = serve_url
        build(cfg, serve_url=serve_url, dirty=False)

    server = LiveReloadServer(builder=builder, host=host, port=port, root=site_dir, mount_path=mount_path)
    server.watch(config.docs_dir)
    if config.config_file_path:
        server.watch(config.config_file_path)
    for item in config.watch:
        server.watch(item)

    server = config.plugins.on_serve(server, config=config, builder=builder)

    try:
        builder(config)
        server.serve(open_in_browser=False)
    except KeyboardInterrupt:
        return 0
    finally:
        server.shutdown(wait=True)
        config.plugins.on_shutdown()
        shutil.rmtree(site_dir, ignore_errors=True)


if __name__ == "__main__":
    raise SystemExit(main())
