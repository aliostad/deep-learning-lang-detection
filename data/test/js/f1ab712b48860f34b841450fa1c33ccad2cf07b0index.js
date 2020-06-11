
export function ShowStage(){

     return((dispatch)=>{ dispatch(
         {
           type:"SHOW_STAGE",
            payload:{
                Stage:true
            }}
          )
        })
    }	
	
export function CloseStage(){

     return((dispatch)=>{ dispatch(
         {
           type:"CLOSE_STAGE",
            payload:{
                Stage:false
            }}
          )
        })
    }	
		
export function SelectedShowcase(project){

     return((dispatch)=>{ dispatch(
         {
           type:"SELECTED_SHOWCASE",
            payload:{
                project:project
            }}
          )
        })
    }	
	
	
export function inputTrue(input)
	{
		
		return((dispatch)=>{ dispatch(
         {
           type:"INPUT_TRUE",
            payload:{
                input:input
            }}
          )
        })
	}	