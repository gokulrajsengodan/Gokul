import { LightningElement, track,api} from 'lwc';
import getCurrentTodos from "@salesforce/apex/ToDoController.getCurrentTodos";
import addTodo from "@salesforce/apex/ToDoController.addTodo";
export default class Todomanager extends LightningElement {
		
		@track time="";
		@track greeting="";
		@track todos=[];
		@api flexipageRegionWidth;
		
		connectedCallback(){
				setInterval(()=>{
				this.getTime();
				},1000);
		}
		
		getTime(){
				const date=new Date();
				const hour=date.getHours();
				const min=date.getMinutes();
				this.time = `${this.getHour(hour)} : ${this.getMin(min)} ${this.getDay(hour)}`;
				this.setGreeting(hour);
		}
		
		getHour(hour){
				return hour === 0 ? 12 : hour>12 ? (hour-12) : hour ;
		}
		
		getMin(min){
				return min < 10 ? "0"+min : min;
		}
		
		getDay(hour){
				return hour >= 12 ? "PM" : "AM" ;
		}
		
		setGreeting(hour){
				if(hour<12){
						this.greeting="Good Morning";
				}
				else if(hour>=12 && hour<17){
						this.greeting="Good Afternoon";
				}
				else if(hour>=17 && hour<21){
						this.greeting="Good Evening";
				}
				else {
						this.greeting="Good Night";
				}
		}
	addTodoHandler() {
    //get input box html element
    const inputBox = this.template.querySelector("lightning-input");
    //create a new todo object based on input box value
    const todo = { todoName: inputBox.value, done: false };
    //call addtodo server method to add new todo object
    //serialize todo object before sending to server
    addTodo({ payload: JSON.stringify(todo) })
      .then(result => {
        if (result) {
          //fetch fresh list of todos
          this.fetchTodos();
        }
      })
      .catch(error => {
        console.error("Error in adding todo" + error);
      });

    inputBox.value = "";
  }

  /**
   * Fetch todos from server
   * This method only retrives todos for today
   */
  fetchTodos() {
    getCurrentTodos()
      .then(result => {
        if (result) {
          //update todos property with result
          this.todos = result;
        }
      })
      .catch(error => {
        console.error("Error in fetching todo" + error);
      });
  }

  /**
   * Fetch fresh list of todos once todo is updated
   * This method is called on update event
   * @param {*} event
   */
  updateTodoHandler(event) {
    if (event) {
      this.fetchTodos();
    }
  }

  /**
   * Fetch fresh list of todos once todo is deleted
   * This method is called on delete event
   * @param {*} event
   */
  deleteTodoHandler(event) {
    if (event) {
      this.fetchTodos();
    }
  }

  // get property to return upcoming/unfinished todos
  get upcomingTodos() {
    return this.todos && this.todos.length
      ? this.todos.filter(todo => !todo.done)
      : [];
  }

  // get property to return completed todos
  get completedTodos() {
    return this.todos && this.todos.length
      ? this.todos.filter(todo => todo.done)
      : [];
  }

  //Get input box size based on current screen width
  get largePageSize() {
    return this.flexipageRegionWidth === "SMALL"
      ? "12"
      : this.flexipageRegionWidth === "MEDIUM"
      ? "8"
      : "6";
  }

}