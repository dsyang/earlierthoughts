import firebase from "firebase"
import { configs } from "../firebase-config"

interface Signature {
    form: HTMLFormElement,
    text: string,
    push_token: string,
    push_permission_status: "default" | "granted" | "denied"
    on_init(): Promise<void>,
    isPushGranted(): boolean,
    isPushDenied(): boolean,
    isPushUnknown(): boolean,
    enablePush(): Promise<string>
}

function form_component(form: HTMLFormElement): Signature {
    return {
        form: form,
        text: '',
        push_token: '',
        push_permission_status: "default",
        async on_init() {
            this.push_permission_status = window.Notification.permission
            if (this.push_permission_status == "granted") {
                this.push_token = await getPushToken()
            }
        },
        isPushDenied() { return this.push_permission_status == "denied" },
        isPushGranted() { return this.push_permission_status == "granted" },
        isPushUnknown() { return this.push_permission_status == "default" },
        async enablePush() {
            return getPushToken()
        }
    }
}

async function getPushToken() {
    const messaging = firebase.messaging();
    const sw_registration: Promise<ServiceWorkerRegistration> = navigator.serviceWorker.register("/js/sw.js");
    const serviceWorker = await sw_registration;
    // always update service worker to get new code.
    // Not correct but simpler than https://redfin.engineering/how-to-fix-the-refresh-button-when-using-service-workers-a8e27af6df68
    console.log('updating service worker')
    serviceWorker.update()
    console.log('updated')
    return messaging.getToken({
        vapidKey: configs.firebaseVapid,
        serviceWorkerRegistration: serviceWorker,
    })
}

export default form_component