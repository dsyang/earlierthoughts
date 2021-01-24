declare module 'alpinejs' {

    export function clone(from: Component, to: HTMLElement): void

    export interface HasComponent extends HTMLElement {
        __x: Component?
    }
}


declare class Component {
    constructor(el: HTMLElement, componentForClone: any?)
};
