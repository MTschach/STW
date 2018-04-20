class Browser {
    
    static appName:string   = "";
    static mobile:boolean   = false;
    
    constructor() {
    }
    
    
    static getWindowHeight():number {
        return window.innerHeight;
    }
    
    static getWindowWidth():number {
        return window.innerWidth;
    }
    
    
    static isAndroid():boolean {
        return /Android/i.test(navigator.userAgent);
    }
    
    
    static isBlackberry():boolean {
        return /BlackBerry/i.test(navigator.userAgent);
    }
    
    
    static isIos():boolean {
        return /iPhone|iPad|iPod/i.test(navigator.userAgent);
    }
    
    
    static isOperaMobile():boolean {
        return /Opera Mini/i.test(navigator.userAgent);
    }
    
    
    static isWindowsMobile():boolean {
        return /IEMobile|WPDesktop/i.test(navigator.userAgent);
    }
    
    
    static isMobile():boolean {
        return this.isAndroid() || this.isBlackberry() || this.isIos() || this.isOperaMobile() || this.isWindowsMobile();
    }
}