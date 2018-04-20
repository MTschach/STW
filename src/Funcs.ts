class Funcs {
    static cookie: Cookie = new Cookie();

    constructor() {
    }
    
    
    static appendBrowserEvents():string {
        return "";
    }
    
    
    static checkMinWindowHeight(height:number):number {
        if (Browser.isMobile()) {
            return height;
        }
        
        return (height < 600 ? 600 : height)
    }
    
    
    static checkMinWindowWidth(width:number):number {
        if (Browser.isMobile()) {
            return width;
        }
        
        
        return (width < 800 ? 800 : width)
    }
    
    
    static getElement(name:string):HTMLElement {
        if (name === null || name == "")
            return null;
        
        let elem = document.getElementById(name);
        if (elem !== null)
            return elem;
        
        let elems = document.getElementsByName(name);
        if (elems !== null && elems.length > 0) {
            return elems[0];
        }
        
        return undefined;
    }
    
    
    static getValue(name:string):any {
        
        let elem:HTMLElement = Funcs.getElement(name);
        if (elem === null)
            return null;
        
        switch (elem.nodeName) {
            case "INPUT":
                return Funcs.getInputValue(<HTMLInputElement>elem);
        
            default:
                return elem.innerHTML;
        }
    }
    
    
    static getInputValue(elem:HTMLInputElement):string {
        if (elem === null)
            return null;
        
        switch (elem.type.toUpperCase()) {
            case "PASSWORD":
            case "TEXT":
                return elem.value;
        
            default:
                return elem.innerHTML;
        }
    }
    
    
    static loadCss(url:string, id:string, callback) {
        let oldCss = null;
        
        if (id !== null && id != "")
            oldCss = document.getElementById("UserCss");
        
        let css = document.createElement('link');
        css.id = "UserCss";
        css.rel = "stylesheet";
        css.href = url;
        
//        if (callback) {
//            script.onload = function () {
//                callback();
//            }
//        }
        
        try {
            if (oldCss !== null)
                document.head.replaceChild(oldCss, css);
            else
                document.head.appendChild(css);
        }
        catch (e) {
            document.head.appendChild(css);
        }
    }
    
    
    static loadPage() {
        switch (this.cookie.getCurrentPage()) {
            case "Main":
                new Main().initMainPage();
                break;
            default:
                new Index().initIndexPage();
                break;
        }
        
        Main.scaleMainDivs();
    }
    
    
    static loadScript(url:string, id:string, callback) {
        let oldScript = null;
        
        if (id !== null && id != "")
            oldScript = document.getElementById("TranslatedTexts");
        
        let script = document.createElement('script');
        script.id = "TranslatedTexts";
        script.type = "text/javascript";
        script.src = url;
        
        if (callback) {
            script.onload = function () {
                callback();
            }
        }
        
        try {
            if (oldScript !== null)
                document.head.replaceChild(oldScript, script);
            else
                document.head.appendChild(script);
        }
        catch (e) {
            document.head.appendChild(script);
        }
    }
    
    
    static login() {
        var user: string = this.getValue("UserName");
        var pass: string = this.getValue("UserPasswd");
    
        if (user == "" || pass == "")
            return;
        
        this.cookie.setSession(user+"_-_"+pass);
        this.cookie.setCurrentPage("Main");
        this.cookie.writeCookie();
        
        if (user.indexOf("race1", 0) >= 0)
            this.loadCss("css/race1.css", "UserCss", null);
        
        this.loadPage();
    }
    
    
    static logout() {
        this.cookie.setSession("");
        this.cookie.setCurrentPage("index");
        this.cookie.writeCookie();
        
        this.unloadCss("UserCss");
        
        this.loadPage();
    }
    
    
    static getText(key:string):string {
        if (TRANSLATIONS[key] != undefined)
            return TRANSLATIONS[key];
        
        return key;
    }
    
    
    static setLanguage(lang:string, forceLoad:boolean = false) {
        if (this.cookie.getLanguage() == lang && !forceLoad)
            return;
        
        this.cookie.setLanguage(lang);
        this.cookie.writeCookie();
        
        this.loadScript("js/Texte_" + lang + ".js", "TranslatedTexts", function() { Funcs.loadPage(); });
    }
    
    
    static unloadCss(id:string) {
        let oldCss = null;
        
        if (id !== null && id != "")
            oldCss = document.getElementById(id);
        
        if (oldCss !== null)
            document.head.removeChild(oldCss)
    }
    
    


}