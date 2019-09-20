class PasswordCheck {
    constructor() {}
    
    analysePassword(password:string, login:string):number {
        let v : number = 0;
        if (password == null || login == null || password.length < 1)
            return 0;
        
        v = analyseLength(password) + analyseDifferentChars(password) + analyseCase(password) + analyseDigitsAndSpecialChars(password) + checkPasswordWithLogin(password, login);
        
        return v / (password.length * 3);
    }
    
    
    protected analyseLength(password:string):number {
        if (password == null)
            return 0;
        
        return password.length;
    }
    
    
    protected analyseDifferentChars(password:string):number {
        if (password == null)
            return 0;
        
        let maxCount:number = 0;
        for (let i=0; i<password.length-1; i++) {
            let count:number = 0;
            for (let j=i+1; j<password.length; j++) {
                if (password.charAt(i) == password.charAt(j))
                    count++;
            }
            if (count > maxCount)
                maxCount = count;
        }
    
        return -maxCount;
    }


    protected analyseCase(password:string):number {
        if (password == null)
            return 0;
        
        if (password.toLowerCase() == password)
            return -password.length/2;
        if (password.toUpperCase() == password)
            return -password.length/2;
        return 0;
    }
    
    
    protected analyseDigitsAndSpecialChars(password:string):number {
        let countLetter:number = 0;
        let countDigit:number = 0;
        let countSpecial:number = 0;
    
        if (password == null)
            return 0;
    
        for (let i=0; i<password.length; i++) {
            if (/^A-Z$/i.test(password.charAt(i))) countLetter++;
            else if(/^0-9$/.test(password.charAt(i))) countDigit++;
            else countSpecial++;
        }
        
        return countLetter + 2*countDigit + 3*countSpecial;
    }
        
        
    protected checkPasswordWithLogin(password:string, login:string):number {
        if (password == null || login == null)
            return 0;
        
        let lpwd : string = password.toUpperCase();
        let llogin : string = login.toUpperCase();
        
        for (let i=llogin.length-1; i>2; i--) {
            for (let j=0; j<llogin.length-i; j++) {
                if (lpwd.indexOf(llogin.substring(j, i)) >= 0)
                    return 5*i;
            }
        }
        
        return 0;
    }
}