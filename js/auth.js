async function decryptContents(el) {
    let cipher = str2ab(atob(el.innerText));
    let key = await getKey();
    let res = await crypto.subtle.decrypt({
        name: "AES-CBC",
        iv: getDestroyIV()
    }, key, cipher);
    return (new TextDecoder()).decode(res);
}

async function getKey() {
    //let pass = prompt("Password: ")
    let pass;
    if ("phd_stuff_pass" in localStorage) {
        pass = localStorage.phd_stuff_pass;
    } else {
        pass = prompt("Password? ");
        localStorage.phd_stuff_pass = pass;
    }
    let keysha = await crypto.subtle.digest("SHA-256", str2ab(pass));
    return await crypto.subtle.importKey("raw", keysha, "AES-CBC", false, ["encrypt", "decrypt"])
}

/*
 * UTILITY FUNCTIONS
 */

/*
Convert a string into an ArrayBuffer
from https://developers.google.com/web/updates/2012/06/How-to-convert-ArrayBuffer-to-and-from-String
*/
function str2ab(str) {
  const buf = new ArrayBuffer(str.length);
  const bufView = new Uint8Array(buf);
  for (let i = 0, strLen = str.length; i < strLen; i++) {
    bufView[i] = str.charCodeAt(i);
  }
  return buf;
}

function getDestroyIV() {
    let el = document.getElementById("nonce");
    let iv = str2ab(atob(el.innerText));
    el.remove();
    return iv;
}

// ENTRY POINT

(async function() {
    let el = document.getElementById("encrypted");
    try {
        let decoded = await decryptContents(el);
        el.outerHTML = decoded;
    } catch (e) {
        el.outerHTML = "<h1 style='color: red;'>Wrong password.</h2>";
        localStorage.removeItem("phd_stuff_pass");
    }
})();
