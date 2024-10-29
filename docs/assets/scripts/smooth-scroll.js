document.body.addEventListener("click", e => {
    let link = null;
    let target = e.target;

    while(target != null) {
        if(target.tagName == "A") {
            link = target;
            break;
        } else {
            target = target.parentNode;
        }
    }

    if(link != null) {
        if(link.href.includes("#")) {
            // enable smooth scrolling when clicking on section links
            document.body.parentNode.classList.remove("weavedoc-inhibit-smooth-scrolling");
        } else {
            // disable it everywhere else
            document.body.parentNode.classList.add("weavedoc-inhibit-smooth-scrolling");
        }
    }
})
function applyPrintClass(el) {
    console.log(el);
    if (el.textContent.trim() === "print") {
      el.classList.add("light-blue");
    }
    const nextElementSibling = el.nextElementSibling;
    if (
      nextElementSibling &&
      nextElementSibling.matches("span.p") &&
      nextElementSibling.textContent.trim() === "." &&
      el.textContent.trim() === "BrickColor"
    ) {
        el.classList.add("light-blue");
        
        const nextNext = nextElementSibling.nextElementSibling

        if (nextNext) {
            nextNext.classList.add("light-blue");
        }
    }
    if (el.textContent.trim() === "task" || el.textContent.trim() === "Enum" || el.textContent.trim() == "wait" || el.textContent.trim() == "require" || el.textContent.trim() == "workspace") {
        el.classList.add("light-blue");
      }
  }
  
document.querySelectorAll("span").forEach(applyPrintClass);
  
const observer = new MutationObserver((mutations) => {
    mutations.forEach((mutation) => {
        mutation.addedNodes.forEach((node) => {
        if (node.nodeType === Node.ELEMENT_NODE && node.tagName === "SPAN") {
            applyPrintClass(node);
        }

        node.querySelectorAll && node.querySelectorAll("span").forEach(applyPrintClass);
        });
    });
});
  
observer.observe(document.body, {
childList: true,
subtree: true
});


function applyNvClassIfAfterDotP(el) {
    const previousSibling = el.previousElementSibling;
    if (
      previousSibling &&
      previousSibling.matches("span.p") &&
      previousSibling.textContent.trim() === "."
    ) {
      el.classList.add("nv-after-dot-p");
    }
}
  
document.querySelectorAll("span.nv").forEach(applyNvClassIfAfterDotP);

const observer2 = new MutationObserver((mutations) => {
mutations.forEach((mutation) => {
    mutation.addedNodes.forEach((node) => {
    if (node.nodeType === Node.ELEMENT_NODE && node.tagName === "SPAN") {
        applyNvClassIfAfterDotP(node);
    }
    node.querySelectorAll && node.querySelectorAll("span.nv").forEach(applyNvClassIfAfterDotP);
    });
});
});

observer2.observe(document.body, {
childList: true,  // Watch for added or removed child elements
subtree: true     // Watch for changes in all child nodes, not just direct children
});
