import { LightningElement, api } from 'lwc';

export default class WebSiteStyle extends LightningElement {

@api height; /* This property is exposed via the XML file. */
		isDataLoaded = false;
    contentDetail = [{ name: 'AGE',
        order: 1, 
        question: 'WHAT IS YOUR AGE?', 
        isImage: false, 
        tabClass: 'tabActive', 
        option: [
            {
                questionNo:1,
                optionClass:'optionInactive',
                value:'<18',
                optionBackgroundColor: 'gray', 
                selectedOptionBackgroundColor: 'orange'
            }, {
                questionNo:1,
                optionClass:'optionInactive',
                value:'18-30',
                optionBackgroundColor: 'gray', 
                selectedOptionBackgroundColor: 'orange'
            }, {
                questionNo:1,
                optionClass:'optionInactive',
                value:'30-60',
                optionBackgroundColor: 'gray', 
                selectedOptionBackgroundColor: 'orange'
            }, {
                questionNo:1,  
                optionClass:'optionInactive',  
            value:'>60',
            optionBackgroundColor: 'gray', 
            selectedOptionBackgroundColor: 'orange'
        }], 
        value: []
    },
    { name: 'ARTIST', 
    order: 2, 
    question: 'WHOSE STYLE DO YOU LIKE THE MOST?', 
    isImage: true, 
    tabClass: 'tabInactive', 
    option: [{
        questionNo:2,
        optionClass:'optionInactive',
        value:'https://www.w3schools.com/w3css/img_snow_wide.jpg',
        optionBackgroundColor: 'gray', 
        selectedOptionBackgroundColor: 'orange'
    }, {
        questionNo:2,
        optionClass:'optionInactive',
        value:'https://www.w3schools.com/w3css/img_nature_wide.jpg',
        optionBackgroundColor: 'gray', 
        selectedOptionBackgroundColor: 'orange'
    }], 
    value: [] 
},
    { name: 'ADVENTURE', 
    order: 3, 
    question: 'HOW ADVENTUROUS IS YOUR STYLE?', 
    isImage: false, 
    tabClass: 'tabInactive', 
    option: [
        {
            questionNo:3,
            optionClass:'optionInactive',
            value:'OUT-THERE',
            optionBackgroundColor: 'gray', 
            selectedOptionBackgroundColor: 'orange'
        }, {
            questionNo:3,
            optionClass:'optionInactive',
            value:'MORE OUT-THERE',
            optionBackgroundColor: 'gray', 
            selectedOptionBackgroundColor: 'orange'
        }, {
            questionNo:3,
            optionClass:'optionInactive',
            value:'CLASSIC',
            optionBackgroundColor: 'gray', 
            selectedOptionBackgroundColor: 'orange'
        }, {
            questionNo:3,
            optionClass:'optionInactive',
            value:'NEUTRAL',
        optionBackgroundColor: 'gray', 
        selectedOptionBackgroundColor: 'orange'
    }],
    value: [] 
},
    { name: 'SHOES', 
    order: 4, 
    question: 'WHICH SIZE SHOES DO YOU WANT?', 
    isImage: false, 
    tabClass: 'tabInactive', 
    option: [
        {
            questionNo:4,
            optionClass:'optionInactive',
            value:8,
            optionBackgroundColor: 'gray', 
            selectedOptionBackgroundColor: 'orange'
        }, {
            questionNo:4,
            optionClass:'optionInactive',
            value:9,
            optionBackgroundColor: 'gray', 
            selectedOptionBackgroundColor: 'orange'
        }, {
            questionNo:4,
            optionClass:'optionInactive',
            value:10,
            optionBackgroundColor: 'gray', 
            selectedOptionBackgroundColor: 'orange'
        }, {
            questionNo:4,
            optionClass:'optionInactive',
            value:11,
        optionBackgroundColor: 'gray', 
        selectedOptionBackgroundColor: 'orange'
    }],
    value: [] 
},
    { name: 'STYLE', 
    order: 5, 
    question: 'WHICH SHOE STYLE DO YOU WANT?', 
    isImage: false, 
    tabClass: 'tabInactive', 
    option: ['NORMAL', 'MEDIUM', 'PREMIUM'], 
    option: [
        {
            questionNo:5,
            optionClass:'optionInactive',
            value:'OUT-THERE',
            optionBackgroundColor: 'gray', 
            selectedOptionBackgroundColor: 'orange'
        }, {
            questionNo:5,
            optionClass:'optionInactive',
            value:'MORE OUT-THERE',
            optionBackgroundColor: 'gray', 
            selectedOptionBackgroundColor: 'orange'
        }, {
            questionNo:5,
            optionClass:'optionInactive',
            value:'CLASSIC',
            optionBackgroundColor: 'gray', 
            selectedOptionBackgroundColor: 'orange'
        }, {
            questionNo:5,
            optionClass:'optionInactive',
            value:'NEUTRAL',
        optionBackgroundColor: 'gray', 
        selectedOptionBackgroundColor: 'orange'
    }],
    value: [] 
}
    ];
    size;
    orderNumber = 1;
    previousBtnShow = false;
    nextBtnShow = true;
    selectContent;
    showContent = false;
    @api content;
    @api quizName;
    result;
    quizData;


    /* A lifecycle hook that is Called after every render of the component. */
    renderedCallback() {

        this.initCSSVariables();

        /* JFYI, use a flag if you only want to run this logic on first render of the component. */

    }

    initCSSVariables() {
        var css = document.body.style;
        this.height = '50px';
        css.setProperty('--modalHeight', this.height);
        console.log('--modalHeight' + this.height);
    }

    connectedCallback() {
        this.content=this.contentDetail;
        this.size = this.content.length;
    }

    onChangeColor(event) {
        console.log('evett -->' + event.target.dataset.id);
        const theDiv = this.template.querySelector('button[data-name="' + event.target.dataset.name + '"]');
        const theDiv1 = this.template.querySelectorAll('button[data-id="button"]');
        console.log('theDiv -->' + theDiv);
        console.log('theDiv  -->' + theDiv.style.backgroundColor);
        for (let s of theDiv1) {
            if (s.style.backgroundColor == "orange") {
                s.style.backgroundColor = "";
            }
        }
        theDiv.style.backgroundColor = "orange";
        this.orderNumber = event.target.dataset.order;
        console.log('this.orderNumber -->' + this.orderNumber);
        console.log('Array number -->'+(this.orderNumber-1));
         this.selectContent = [];
        this.selectContent = this.content[this.orderNumber-1];
        console.log('this.selectContent -->'+this.selectContent);
         this.buttonDisabledFtn(event);
    }

    onPageLogic(event) {
        const theDiv1 = this.template.querySelectorAll('button[data-id="button"]');
        const buttonName = event.target.dataset.name;
        let number;
        for (let s of theDiv1) {
            if (s.style.backgroundColor == "orange") {
                console.log('theDiv  -->' + s.dataset.order);
                number = s.dataset.order;
                console.log('number -->'+number);
                s.style.backgroundColor = "";
            }
        }
        if(buttonName == 'Previous'){
                  this.orderNumber = Math.floor(number)-1;
        }else{
                    this.orderNumber = Math.floor(number)+1;
        }
        const theDiv = this.template.querySelector('button[data-order="' + this.orderNumber+ '"]');
        console.log('theDiv last  -->' + theDiv);
        theDiv.style.backgroundColor = "orange";
                 this.selectContent = [];
        this.selectContent = this.content[this.orderNumber-1];
        this.buttonDisabledFtn();
    }
    
    

    
    buttonDisabledFtn()
    {
        if (this.orderNumber == this.size) {
            this.nextBtnShow = false;
            this.previousBtnShow = true;
        } else if (this.orderNumber > 1) {
            this.nextBtnShow = true;
            this.previousBtnShow = true;
        } else {
            this.nextBtnShow = true;
            this.previousBtnShow = false;
        }
        this.showContent = true;
        console.log('this.nextBtnShow -->' + this.nextBtnShow);
    }

    handleValueChange(event){
             
    }
}