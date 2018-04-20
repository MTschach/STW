class Main {
    
    constructor() {}
    
    
    initMainPage() {
        try {
            var content : string = "";
            Funcs.cookie.getLanguage();
        
            content += "<div id=\"Banner\" class=\"Banner\" style=\"left:0px; top:0px; width: 1024px; height: 75px; position: absolute;\">";
            content += "</div>";

            content += "<div id=\"Toolbar\" class=\"Toolbar\" style=\"left:0px; top:75px; width: 1024px; height: 75px; position: absolute;\">";

            content += "<table width=\"100%\">";
            content += "<tr>";
            content += "<td>" + this.writeMenu() + "</td><td align=\"right\">";
            content += CommonElements.writeLanguages();
            content += "</td>";
            content += "</tr>";
            content += "</table>";
            
            content += "</div>";
            
            content += "<div id=\"Maindiv\" class=\"Main\" style=\"left:150px; top:150px; width: 874px; height: 675px; position: absolute;\">";
            content += "</div>";
            
            content += "<div id=\"Status\" class=\"Status\" style=\"left:0px; top:150px; width: 150px; height: 150px; position: absolute;\">";
            content += "</div>";
            
            content += "<div id=\"Sidebar\" class=\"Sidebar\" style=\"left:0px; top:300px; width: 150px; height: 525px; position: absolute;\">";
            content += "</div>";
            
            content += "</div>";
            
            content += Funcs.appendBrowserEvents();
            
            Funcs.getElement("BODY_DIV").innerHTML = content;
        }
        catch (e) {
            alert(e);
        }
    }
    
    
    static scaleMainDivs() {
        let windowWidth:number  = Funcs.checkMinWindowWidth(Browser.getWindowWidth());
        let windowHeight:number = Funcs.checkMinWindowHeight(Browser.getWindowHeight());
        let offsetHeight:number = 0;
        let offsetSidebar:number = 0;
        let offsetMain:number = 0;
        
        offsetHeight = this.scaleBanner(Funcs.getElement("Banner"), windowWidth, windowHeight, offsetHeight);
        offsetHeight = this.scaleToolbar(Funcs.getElement("Toolbar"), windowWidth, windowHeight, offsetHeight);
        offsetSidebar = this.scaleStatus(Funcs.getElement("Status"), windowWidth, windowHeight, offsetHeight);
        offsetMain = this.scaleSidebar(Funcs.getElement("Sidebar"), windowWidth, windowHeight, offsetSidebar);
        this.scaleMain(Funcs.getElement("Maindiv"), windowWidth, windowHeight, offsetMain, offsetHeight);
    }
    
    
    static scaleBanner(div:HTMLElement, width:number, height:number, offset:number):number {
        if (div == null)
            return offset;
        
        if (Browser.isMobile()) {
            div.style.left   = "0px";
            div.style.top    = offset + "px";
            div.style.width  = width + "px";
            div.style.height = "40px";
            
            return offset + 40;
        }
        
        div.style.left   = "0px";
        div.style.top    = offset + "px";
        div.style.width  = width + "px";
        div.style.height = "75px";
        
        return offset + 75;
    }
    
    
    static scaleMain(div:HTMLElement, width:number, height:number, offsetLeft:number, offsetTop:number) {
        if (div == null)
            return;
        
        div.style.left   = offsetLeft + "px";
        div.style.top    = offsetTop  + "px";
        div.style.width  = (width - offsetTop) + "px";
        div.style.height = (height - offsetLeft) + "px";
    }
    
    
    static scaleSidebar(div:HTMLElement, width:number, height:number, offset:number):number {
        if (div == null)
            return offset;
        
        if (Browser.isMobile()) {
            div.style.left   = "0px";
            div.style.top    = offset + "px";
            div.style.width  = "15px";
            div.style.height = (height - offset) + "px";
            
            return 15;
        }
        
        div.style.left   = "0px";
        div.style.top    = offset + "px";
        div.style.width  = "150px";
        div.style.height = (height - offset) + "px";
        
        return 150;
    }
    
    
    static scaleStatus(div:HTMLElement, width:number, height:number, offset:number):number {
        if (div == null)
            return offset;
        
        if (Browser.isMobile()) {
            div.style.left   = "0px";
            div.style.top    = offset + "px";
            div.style.width  = "15px";
            div.style.height = "100px";
            
            return offset + 100;
        }
        
        div.style.left   = "0px";
        div.style.top    = offset + "px";
        div.style.width  = "150px";
        div.style.height = "150px";
        
        return offset + 150;
    }
    
    
    static scaleToolbar(div:HTMLElement, width:number, height:number, offset:number):number {
        if (div == null)
            return offset;
        
        if (Browser.isMobile()) {
            div.style.left   = "0px";
            div.style.top    = offset + "px";
            div.style.width  = width + "px";
            div.style.height = "40px";
            
            return offset + 40;
        }
        
        div.style.left   = "0px";
        div.style.top    = offset + "px";
        div.style.width  = width + "px";
        div.style.height = "75px";
        
        return offset + 75;
    }
    
    
    writeMenu():string {
        let content:string = "";
        
        content = "<span onClick=\"javascript:Funcs.logout();\">" + Funcs.getText("TXT_LOGOUT") + "</span>";
        
        return content;
    }
}