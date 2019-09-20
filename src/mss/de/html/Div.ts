class Div extends HTMLElement {
    protected tag:string = "div";
    
    public constructor(theName:string, theClass?: string) {
        super();
        name = theName;
        class = theClass;
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