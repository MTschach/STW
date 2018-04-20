class Cookie {
    language: string        = "en";
    idUser: number          = 0;
    displayName: string     = "";
    timeout: number         = 3600;
    userType: string        = "";
    session: string         = "1";
    validUntil:Date         = new Date();
    currentPage: string     = "login";

    constructor() {
        this.readCookie();
    }
    
    
    getCurrentPage() {
        return this.currentPage;
    }
    
    
    getLanguage() {
        return this.language;
    }
    
    
    getIdUser() {
        return this.idUser;
    }
    
    
    getDisplayName() {
        return this.displayName;
    }
    
    
    getSession() {
        return this.session;
    }
    
    
    readCookie() {
        var currentCookie: string;
        
        currentCookie = document.cookie;
        if (currentCookie == null)
            return;
        
        var cookieParts: string[] = currentCookie.split(';');
        
        for (var i:number=0; i<cookieParts.length; i++)
            this.readCookieValue(cookieParts[i]);
        
        this.validUntil = new Date();
        this.validUntil.setTime(this.validUntil.getTime() + this.timeout*1000);
    }
    
    
    readCookieValue(cookiePart:string) {
        if (cookiePart == null)
            return;
        
        var keyValue: string[] = cookiePart.split('=');
        if (keyValue.length >= 2)
            this.parseKeyValue(keyValue[0].trim(), keyValue[1].trim());
    }
    
    
    parseKeyValue(key:string, value:string) {
        switch(key) {
            case "language":
                this.language = value;
                break;
            
            case "session":
                this.session = value;
                break;
                
            case "userType":
                this.userType = value;
                break;
                
            case "displayName":
                this.displayName = value;
                break;
                
            case "idUser":
                this.idUser = parseInt(value, 10);
                break;
                
            case "currentPage":
                this.currentPage = value;
                break;
        }
    }
    
    
    writeCookie() {
        var expires: Date       = new Date();
        expires.setTime(expires.getTime() + this.timeout*1000);
        var expiresToDelete     = new Date();
        expiresToDelete.setTime(1);
        var expiresLongTerm     = new Date();
        expiresLongTerm.setTime(expiresLongTerm.getTime() + 180*24*3600*1000);
        
        if (new Date().getTime() > this.validUntil.getTime()) {
            this.session = "";
            this.currentPage = "login";
        }
        
        if (this.language == "" || this.language == null)
            this.language = "en";
            
        document.cookie = "language=" + this.language + "; expires=" + expiresLongTerm.toUTCString();
        document.cookie = "currentPage=" + this.currentPage;
        
        if (this.session != "") {
            document.cookie = "displayName=" + this.displayName + "; expires=" + expires.toUTCString();
            document.cookie = "idUser=" + this.idUser + "; expires=" + expires.toUTCString();
            document.cookie = "session=" + this.session + "; expires=" + expires.toUTCString();
            document.cookie = "userType=" + this.userType + "; expires=" + expires.toUTCString();
        }
        else {
            document.cookie = "displayName=" + this.displayName + "; expires=" + expiresToDelete.toUTCString();
            document.cookie = "idUser=" + this.idUser + "; expires=" + expiresToDelete.toUTCString();
            document.cookie = "session=" + this.session + "; expires=" + expiresToDelete.toUTCString();
            document.cookie = "userType=" + this.userType + "; expires=" + expiresToDelete.toUTCString();
        }
    }
    
    
    isSessionValid() {
        return this.session != "";
    }
    
    
    setLanguage(lang:string) {
        this.language = lang;
    }
    
    
    setDisplayName(value:string) {
        this.displayName = value;
    }
    
    
    setSession(value:string) {
        this.session = value;
    }
    
    
    setIdUser(value:number) {
        this.idUser = value;
    }
    
    
    setUserType(value:string) {
        this.userType = value;
    }
    
    
    setCurrentPage(value: string) {
        this.currentPage = value;
    }
}