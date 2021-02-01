import "../../css/app.scss"
import Alpine from "alpinejs";
import "phoenix_html"
import { Socket } from "phoenix"
import NProgress from "nprogress"
import { LiveSocket } from "phoenix_live_view"
import ListViewForm from "./list_view_form_component"

let csrfToken = document.querySelector("meta[name='csrf-token']")?.getAttribute("content")
let liveSocket = new LiveSocket(
    "/live", Socket,
    {
        params: {
            _csrf_token: csrfToken
        },
        dom: {
            onBeforeElUpdated(from, to) {
                let fromEl = from as Alpine.HasComponent
                if (fromEl.__x) {
                    Alpine.clone(fromEl.__x, to);
                }
                return false;
            }
        }
    })

// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", info => NProgress.start())
window.addEventListener("phx:page-loading-stop", info => NProgress.done())

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose alpinejs components to the front-end scope for use in phoenix templates
(window as any).listViewForm = ListViewForm;

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
(window as any).liveSocket = liveSocket
