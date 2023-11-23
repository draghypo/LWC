/*											LIFECYCLE HOOKS OF LWC
 										 -----------------------------

	=> LIFECYCLE HOOKS:- A lifecycle hook is a callback method triggered at a specific phase of a component
						instance’s lifecycle.
											Phase of hooks
		-----------------------------------------------------------------------------------------
		|						|					|
	Mounting Phase					Unmounting Phase			Error Phase
	a). constructor()				a). disconnectedCallback()		a).errorCallback(error, stack) 
	b). connectedCallback()
	c). renderedCallback()
	
	Note:-The render() method is not technically a lifecycle hook. It is a protected method on the 
				LightningElement.will discuss about render() below.

			=> Mounting Phase:- Placing the component to DOM.
			=> Unmounting Phase:- Removing the component from DOM.
			=> Error Phase:- when error occur in Mounting or Unmounting  phase.

	Flow of Hooks:- 
		Parent component===>Constructor====>Public Property to update===>Component Inserted into DOM===⌄
																									   ||
  follow same process from constructor(if true)child component<===component rendered<===connectedCallback
										 ||
										 ⌄
									 (if false)==>renderedCallback==> Component lifecycle end.

	conculsion of flow:- when component load into the salesforce engine.
						a). constructor called.
						b). Update public property
						c). check component inserted into DOM
						d). connectedcallback
						e). component rendered
						f). if component is having any child component then it will go to the child component from 
							constructor to component rendered and renderedcallback as well then parent
							renderedcallback.
						g). renderedcallback
						h). component lifecycle hooks ends.

	=> constructor():- This hook is invoked when a component is created.
				Points:-
						a). The first statement must be the super() with no parameters.
                                syntax:- constructor() {
                                			super();
											------
											------
                                		}
						b). The constructor flows from parent to child.
						c). We can not access child element in the component body because they do not exist yet.
						d). we can call apex method inside the constructor.
						e). you can not access the element inside the constructor.
								ex:- this.template.querySelector('lightning-button'); through an error beacause of
											component is not inserted into DOM yet.

	=> connectedCallback():- This hook is invoked when a component inserted into DOM.
                        syntax:- connectedcallback() {
                                	-----------
									-----------
                        		}
				Points:- 
						a). The hook flow from parent to child.
						b). we can not access the child element in parent connectedcallback because they do not
								exits yet.

	=> renderedCallback():- This hooks invoked after every render of the component. And used to interact with
							a component's UI.
                    syntax:- renderedCallback() {
                                -----------
                                -----------
                            }
				Points:- 
						a). It can fire more than once. 
						b). The hook flow child to parent.

	=> Example of mouting phase on parent and child components.
	
		So, creating two components 1) Parent component  2) Child component

									Parent component
								 ---------------------
			HTML
		   -------
                <template>
                    <lightning-card variant="Narrow" title="Parent component" icon-name="standard:account">
                        <c-child-component></c-child-component>
                    </lightning-card>
                
                </template>

			JAVASCRIPT
		  --------------
                import { LightningElement } from 'lwc';
                export default class ParentComponent extends LightningElement {
                
                    constructor() {
                        super();
                        console.log('Parent constructor called');
                    }
                
                    connectedCallback() {
                        console.log('Parent connectedcallback called');
                    }
                
                    renderedCallback() {
                        console.log('Parent rendered callback called');
                    }
                
                }
									Child component
								 ---------------------
			HTML
		   -------
                <template>
                    <lightning-card variant="Narrow" title="Child component" icon-name="standard:account">
                    </lightning-card>
                </template>

			JAVASCRIPT
		  --------------
                    import { LightningElement } from 'lwc';
                    export default class ChildComponent extends LightningElement {
                    
                        constructor() {
                            super();
                            console.log('Child constructor called');
                        }
                    
                        connectedCallback() {
                            console.log('Child connectedcallback called');
                        }
                    
                        renderedCallback() {
                            console.log('Child rendered callback called');
                        }
                    
                    }

							Loading Parent components 
						   ---------------------------
		OUTPUT:- 
                Parent constructor called
                Parent connectedcallback called
                Child constructor called
                Child connectedcallback called
                Child rendered callback called
                Parent rendered callback called

		=> Unmounting Phase:- Removing the component from DOM.

				disconnectedCallback():- This hooks will invoked when the element is removed from a
											DOM. 
                                syntax:- disconnectedCallback() {
                                            -------------
                                            -------------
                                        }
						Points:- 
								a). fire when component is removed from DOM.
								b). it flow from parent to child.

			=> Example of Unmouting phase on parent and child components.
	
				So, creating two components 1) Parent component  2) Child component

									Parent component
								 ---------------------
			HTML
		   -------
<template>
	<lightning-card variant="Narrow" title="Parent component" icon-name="standard:account">
		<lightning-button variant="Destructive" label="SHOW" onclick={handleClickShowButton}></lightning-button>
		<div if:true={childCompo}>
			<c-child-component></c-child-component>
			<lightning-button variant="Destructive" label="HIDE" onclick={handleClickHideButton}></lightning-button>
		</div>
	</lightning-card>
</template>

		JAVASCRIPT
	 ----------------
            import { LightningElement } from 'lwc';
            export default class ParentComponent extends LightningElement {
                childCompo;
            
                constructor() {
                    super();
                    console.log('Parent constructor called');
                }
            
                connectedCallback() {
                    console.log('Parent connectedcallback called');
                }
            
                renderedCallback() {
                    console.log('Parent rendered callback called');
                }
            
                disconnectedCallback() {
                    console.log('Parent disconnectdcallback called');
                }
            
                handleClickShowButton() {
                    this.childCompo = true;
                }
            
                handleClickHideButton() {
                    this.childCompo = false;
                }
            
            }
									Child component
								 ---------------------
			HTML
		   -------
                <template>
                    <lightning-card variant="Narrow" title="Child component" icon-name="standard:account">
                    </lightning-card>
                </template>
		JAVASCRIPT
	  -------------
                    import { LightningElement } from 'lwc';
                    export default class ChildComponent extends LightningElement {
                    
                        constructor() {
                            super();
                            console.log('Child constructor called');
                        }
                    
                        connectedCallback() {
                            console.log('Child connectedcallback called');
                        }
                    
                        renderedCallback() {
                            console.log('Child rendered callback called');
                        }
                    
                        disconnectedCallback() {
                            console.log('Child disconnectdcallback called');
                        }
                    
                    }
							Loading Parent components 
						   ---------------------------
			So, once parent componet visible on UI. It will show parent component with show button.
				now in console it will print.
                                                Parent constructor called
                                                Parent connectedcallback called
                                                Parent rendered callback called
					once we click on the show button. child component will visble with Hide button on UI With
						below console.
                                        Child constructor called
                                        Child connectedcallback called
                                        Child rendered callback called
                                        Parent rendered callback called
	
		and now going to click Hide button of Parent Component then it will hide the hide button and remove the
		child componet. with below console.
                                        Child disconnectdcallback called
                                        Parent rendered callback called

		=> Error Phase:- This will invoke when anyother lifecycle throw an error or get error.
					syntax:-  
                            errorCallback(error, stack) {      // error:- javascript native error
                                console.log(error.message);		// stack:- argument error
                                console.log(stack);
                            }
					example:- Create a two components. parent and child.

						Parent component
					  --------------------
			HTML
		  -------
<template>
	<lightning-card variant="Narrow" title="Parent component" icon-name="standard:account">
		<lightning-button variant="Destructive" label="SHOW" onclick={handleClickShowButton}></lightning-button>
		<div if:true={childCompo}>
			<c-child-component></c-child-component>
			<lightning-button variant="Destructive" label="HIDE" onclick={handleClickHideButton}></lightning-button>
		</div>
	</lightning-card>
</template>

		JAVASCRIPT
  	  --------------
                    import { LightningElement } from 'lwc';
                    export default class ParentComponent extends LightningElement {
                        childCompo;
                        constructor() {
                            super();
                            console.log('Parent constructor called');
                        }
                        connectedCallback() {
                            console.log('Parent connectedcallback called');
                        }
                        renderedCallback() {
                            console.log('Parent rendered callback called');
                        }
                        disconnectedCallback() {
                            console.log('Parent disconnectdcallback called');
                        }
                        handleClickShowButton() {
                            this.childCompo = true;
                        }
                        handleClickHideButton() {
                            this.childCompo = false;
                        }
                        errorCallback(error, stack) {
                            console.log('error call back callled');
                            console.log(stack);
                            console.log(error.message);
                        }
                    }

				CHILD COMPONENT
			  ------------------
		
			HTML
		  --------
                <template>
                    <lightning-card variant="Narrow" title="Child component" icon-name="standard:account">
                    </lightning-card>
                </template>
		JAVASCRIPT
	   ------------
                import { LightningElement } from 'lwc';
                export default class ChildComponent extends LightningElement {
                    constructor() {
                        super();
                        console.log('Child constructor called');
                    }
                    connectedCallback() {
                        console.log('Child connectedcallback called');
                        throw new Error('Loading of child component failed');
                
                    }
                    renderedCallback() {
                        console.log('Child rendered callback called');
                    }
                    disconnectedCallback() {
                        console.log('Child disconnectdcallback called');
                    }
                
                }
	
			OUTPUT WITH CONCULSION:-
						**.Once page loaded Parent component will show with the show button with below console.
                                    Parent constructor called
                                    Parent connectedcallback called
                                    Parent rendered callback called
						**. So, when we click on the show button child component will visible with 
							Hide button with below console.
                                    Child constructor called
                                    Child connectedcallback called
                                    error call back callled
                                    <c-parent-component><c-child-component>
                                    Loading of child component failed
                                    Child rendered callback called
                                    Parent rendered callback called
							**. so, once we click on the hide button child component will not show with below
									console.
										Child disconnectdcallback called
										Parent rendered callback called
                                    

		=> render():- It's not a part of lifecycle hook. generally the main purpose of render() method to 
					  update the UI.The render() method runs whenever the event action happens. 

			Usage:- instead of <div if:true=""></div> we use render method but it is not suitable for 
					less components if you have more. then go with the render method. it's a predefined 
					method. 	
				syntax:- render() {
    						return this.showTemplateOne ? templateOne : templateTwo;
  						}

				Example:- create component and with three html in one file with one js.
				
				HTML
			  --------
			FIRST HTML
		   -----------
        <template>
            <lightning-card variant="Narrow" title="Render Method example" icon-name="standard:account">
                <lightning-button variant="destructive" label="Go To Template1" onclick={handleGoTOTemplate1}>
                </lightning-button>
                <lightning-button variant="destructive" label="Go To Template2" onclick={handleGoTOTemplate2}>
                </lightning-button>
            </lightning-card>
        </template>
		SECOND HTML
	  ----------------
        <template>
            <lightning-card variant="Narrow" title="ComponentOne" icon-name="standard:account">
            </lightning-card>
        </template>
		THIRD HTML
	  ---------------
        <template>
            <lightning-card variant="Narrow" title="ComponetTwo" icon-name="standard:account">
            </lightning-card>
        </template>

		JAVASCRIPT
	  --------------
        import { LightningElement } from 'lwc';
        import templateOne from './componentOne.html';
        import templateTwo from './componentTwo.html';
        import mainTemplate from './renderExample.html';
        export default class RenderExample extends LightningElement {
            showTemplateOne = mainTemplate;
            render() {
                return this.showTemplateOne;
            }
            handleGoTOTemplate1() {
                this.showTemplateOne = templateOne;
            }
            handleGoTOTemplate2() {
                this.showTemplateOne = templateTwo;
            }
        }
		
		Way of create of componet:- 
				a). create component with the name of RenderExample.
				b). create a html file inside the component with the name of componentOne
				c). create another html file inside the component with the name of componentTwo
				d). for these three html file we have one component.
				e). we have only one js. go with the js.
		OUTPUT
	  ---------
			=> So, on starting you will see RendorExample card with two buttons "Go To Template1" and 
					"Go To Template2" so once you click any of one button rendorexample card will not
					show. which button you clicked that card will show.

*/
public class LwcHooks {}
