class CommonElements {
    static availableLanguages = {
            "en" : "english",
            "de" : "deutsch",
            "es" : "espanol"
    };
    
    constructor() {
    }
    
    
    static writeLanguages():string {
        let content = "";
        
        for (var i in CommonElements.availableLanguages) {
            content += "<span onClick=\"Funcs.setLanguage('" + i + "');\" />";
            if (i == Funcs.cookie.getLanguage())
                content += "<b>" + i + "</b>";
            else
                content += i;
            content += "</span> | ";
        }
        
        return content;
    }
}