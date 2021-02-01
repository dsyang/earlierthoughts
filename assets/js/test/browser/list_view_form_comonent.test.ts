import { expect } from 'chai';
import LiveViewForm from "../../browser/list_view_form_component"
import { JSDOM } from "jsdom"
describe("LiveViewForm", () => {
    beforeEach(() => {
        const dom = new JSDOM(
            `<html>
               <body>
               </body>
             </html>`,
            { url: 'http://localhost' },
        );

        (dom.window as any).Notification = {
            permission: "granted"
        }
        global.document = dom.window.document;
        (global.window as any) = dom.window;


    });

    it("on_load checks notification permissions", () => {

        let component = LiveViewForm()
        component.on_init()
        expect(component.push_permission_status).equals("granted")
    })


    it("permissions checks work", () => {

        let component = LiveViewForm()
        component.on_init()
        expect(component.isPushGranted()).equals(true)

        setNotificationPermissionTo("denied")
        component.on_init()
        expect(component.isPushDenied()).equals(true)


        setNotificationPermissionTo("default")
        component.on_init()
        expect(component.isPushUnknown()).equals(true)
    })
})

function setNotificationPermissionTo(val: NotificationPermission) {
    let notification: { [key: string]: any } = global.window.Notification
    notification.permission = val
}