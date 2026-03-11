function isPathLike(text) {
  if (!text) return false;
  const value = text.trim();
  if (!value) return false;
  if (/^(\/|~\/|\.\.?\/)/.test(value)) return true;
  if (/^[A-Za-z0-9._-]+\/[A-Za-z0-9._/-]+$/.test(value)) return true;
  return false;
}

async function copyText(value) {
  if (navigator.clipboard && navigator.clipboard.writeText) {
    await navigator.clipboard.writeText(value);
    return;
  }

  const area = document.createElement("textarea");
  area.value = value;
  area.setAttribute("readonly", "readonly");
  area.style.position = "absolute";
  area.style.left = "-9999px";
  document.body.appendChild(area);
  area.select();
  document.execCommand("copy");
  document.body.removeChild(area);
}

function decorateInlinePaths() {
  const nodes = document.querySelectorAll(".md-content code");

  nodes.forEach((node) => {
    if (node.closest("pre")) return;
    if (node.dataset.pathCopyBound === "1") return;

    const text = node.textContent || "";
    if (!isPathLike(text)) return;

    node.dataset.pathCopyBound = "1";
    node.classList.add("path-copy-target");

    const button = document.createElement("button");
    button.type = "button";
    button.className = "path-copy-button";
    button.setAttribute("aria-label", `Copy path ${text.trim()}`);
    button.title = "Copy path";
    button.textContent = "Copy";

    button.addEventListener("click", async () => {
      try {
        await copyText(text.trim());
        button.textContent = "Copied";
        window.setTimeout(() => {
          button.textContent = "Copy";
        }, 1200);
      } catch (_error) {
        button.textContent = "Failed";
        window.setTimeout(() => {
          button.textContent = "Copy";
        }, 1200);
      }
    });

    const wrapper = document.createElement("span");
    wrapper.className = "path-copy-inline";
    node.parentNode.insertBefore(wrapper, node);
    wrapper.appendChild(node);
    wrapper.appendChild(button);
  });
}

document.addEventListener("DOMContentLoaded", decorateInlinePaths);
document.addEventListener("DOMContentLoaded", () => {
  if (typeof document$ !== "undefined" && document$.subscribe) {
    document$.subscribe(() => {
      decorateInlinePaths();
    });
  }
});
