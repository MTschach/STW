class HtmlElement {
    
    protected tag:string = null;
    protected name:string = null;
    protected class:string = null;
    protected style:string = null;
    protected onClick:string = null;
    
    public constructor(theName:string, theClass?: string) { 
        this.name = theName;
        this.class = theClass;
    }
    
    
    public getName():string {
        return this.name;
    }
    
    
    public setName(theName:string) {
        this.name = theName;
    }
    
    
    public getClass():string {
        return this.class;
    }
    
    
    public setClass(theClass:string) {
        this.class = theClass;
    }
    
    
    public getStyle():string {
        return this.style;
    }
    
    
    public setStyle(theStyle:string) {
        this.style = theStyle;
    }
    
    
    public getOnClick():string {
        return this.onClick;
    }
    
    
    public setOnClick(theOnClick:string) {
        this.onClick = theOnClick;
    }
    
    
    protected getNameToString():string {
        if (this.name == null || this.name == "")
            return "";
        
        return " name=\"" + this.name + "\" id=\"" + this.name + "\"";
    }
    
    
    protected getClassToString():string {
        if (this.class == null || this.class == "")
            return "";
        
        return " class=\"" + this.class + "\"";
    }
    
    
    protected getStyleToString():string {
        if (this.style == null || this.style == "")
            return "";
        
        return " style=\"" + this.style + "\"";
    }
    
    
    protected getOnClickToString():string {
        if (this.onClick == null || this.onClick == "")
            return "";
        
        return " onClick=\"javascript:" + this.onClick + "\"";
    }
    
    
    public toString():string {
        return "<" + this.tag
            + this.getNameToString()
            + this.getClassToString()
            + this.getStyleToString()
            + this.getOnClickToString()
            + "/>";
    }
    
    
    public writeToDocument() {
        document.write(this.toString())
    }
}