class Index {
    
    constructor() {}
    
    
    initIndexPage() {
        try {
            var content : string;
            Funcs.cookie.getLanguage();
        
            content = Funcs.getText("TXT_CURRENT_LANGUAGE") + " " + Funcs.cookie.getLanguage();

            content += "<p>";
            content += CommonElements.writeLanguages();
            
            content += "<p><input id=\"UserName\" type=\"text\" size=\"15\" maxsize=\"15\"></input>";
            content += "<p><input id=\"UserPasswd\" type=\"password\" size=\"15\" maxsize=\"15\"></input>";
            content += "<p><button onClick=\"Funcs.login();\">" + Funcs.getText("TXT_LOGIN") +"</button>";
            
            content += Funcs.appendBrowserEvents();
            
            Funcs.getElement("BODY_DIV").innerHTML = content;
//            document.body.innerHTML = content;
        }
        catch (e) {
            alert(e);
        }
    }
}