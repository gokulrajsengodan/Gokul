import { LightningElement} from 'lwc';
export default class Calculator extends LightningElement {
		number1;
		number2;
		total;
		connectedCallback(){
				console.log('ttt');
		}
		
		renderedCallback() {
								this.imageZoom();
		}
		
				
		moveImage(){

				console.log('tesy');
			let	img = this.template.querySelector('img[data-id="myimage"]');
				console.log('img -->',img);
			let	result = this.template.querySelector('div[data-id="myresult"]');
				console.log('result -->',result);

		}
		
		addInput() {
    let linput = document.createElement('input');
    this.template.querySelector('.container').appendChild(linput);
}
		
	imageZoom() {
  let img, lens, result, cx, cy;
  img = this.template.querySelector('img[data-id="myimage"]');
  result = this.template.querySelector('div[data-id="myresult"]');
  /*create lens:*/
  lens = document.createElement('div');
			console.log('lens ::',lens);
 // lens.setAttribute("class", "img-zoom-lens");
  /*insert lens:*/
 // img.parentElement.insertBefore(lens, img);
	this.template.querySelector('.img-zoom-container').appendChild(lens);
	console.log('ima ::');
  /*calculate the ratio between result DIV and lens:*/
  cx = result.offsetWidth / lens.offsetWidth;
  cy = result.offsetHeight / lens.offsetHeight;
  /*set background properties for the result DIV:*/
  result.style.backgroundImage = "url('" + img.src + "')";
  result.style.backgroundSize = (img.width * cx) + "px " + (img.height * cy) + "px";
  /*execute a function when someone moves the cursor over the image, or the lens:*/
  lens.addEventListener("mousemove", moveLens);
  img.addEventListener("mousemove", moveLens);
  /*and also for touch screens:*/
  lens.addEventListener("touchmove", moveLens);
  img.addEventListener("touchmove", moveLens);
  function moveLens(e) {
    var pos, x, y;
    /*prevent any other actions that may occur when moving over the image:*/
    e.preventDefault();
    /*get the cursor's x and y positions:*/
    pos = getCursorPos(e);
    /*calculate the position of the lens:*/
    x = pos.x - (lens.offsetWidth / 2);
    y = pos.y - (lens.offsetHeight / 2);
    /*prevent the lens from being positioned outside the image:*/
    if (x > img.width - lens.offsetWidth) {x = img.width - lens.offsetWidth;}
    if (x < 0) {x = 0;}
    if (y > img.height - lens.offsetHeight) {y = img.height - lens.offsetHeight;}
    if (y < 0) {y = 0;}
    /*set the position of the lens:*/
    lens.style.left = x + "px";
    lens.style.top = y + "px";
    /*display what the lens "sees":*/
    result.style.backgroundPosition = "-" + (x * cx) + "px -" + (y * cy) + "px";
  }
  function getCursorPos(e) {
    var a, x = 0, y = 0;
    e = e || window.event;
    /*get the x and y positions of the image:*/
    a = img.getBoundingClientRect();
    /*calculate the cursor's x and y coordinates, relative to the image:*/
    x = e.pageX - a.left;
    y = e.pageY - a.top;
    /*consider any page scrolling:*/
    x = x - window.pageXOffset;
    y = y - window.pageYOffset;
    return {x : x, y : y};
  }
}
		
		
		handleChange(event){
				const value=event.target.value;
				const label=event.target.label;
				if(label == 'Number 1'){
						this.number1=value;
						console.log('alert');
				}else{
						this.number2= value;
				}
		}
		dosum(){
				const sum=parseInt(this.number1) + parseInt(this.number2);
				console.log('Check');
				this.total=sum;
		}
		dosub(){
				const sub=parseInt(this.number1) - parseInt(this.number2);
				this.total=sub;
		}
		domulti(){
				const multi=parseInt(this.number1) * parseInt(this.number2);
				this.total=multi;
		}
		dodiv(){
				const div=parseInt(this.number1) / parseInt(this.number2);
				this.total=div;
		}
		
}