interface Signature {
    text: string,
    push_token: string,
    push_permission_status: "default" | "granted" | "denied"
    on_init(): void,
    isPushGranted(): boolean,
    isPushDenied(): boolean,
    isPushUnknown(): boolean
}

function form_component(): Signature {
    return {
        text: '',
        push_token: '',
        push_permission_status: "default",
        on_init() {
            console.log("loading: " + this.text)
            this.push_permission_status = window.Notification.permission
        },
        isPushDenied() { return this.push_permission_status == "denied" },
        isPushGranted() { return this.push_permission_status == "granted" },
        isPushUnknown() { return this.push_permission_status == "default" }
    }
}


export default form_component