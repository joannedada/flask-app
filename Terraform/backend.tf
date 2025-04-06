terraform { 
  backend "remote" { 
    
    organization = "devopsensei" 

    workspaces { 
      name = "devopsensei" 
    } 
  } 
}