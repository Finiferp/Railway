import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormGroup, FormControl, ReactiveFormsModule } from '@angular/forms'; 
@Component({
  selector: 'app-my-industries',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  templateUrl: './my-industries.component.html',
  styleUrl: './my-industries.component.scss'
})
export class MyIndustriesComponent {
  public industries: any[] = [];          // Array to store the user's industries data retrieved from the server.
  public sessionStorage = sessionStorage;
  token: any;
  userId: any;
  nameControl = new FormControl('');
  typeControl = new FormControl('');


  /**
   * Gets the users industries and inserts them into the "industries" array.
   * @async
   */
  async ngOnInit() {
    this.userId = sessionStorage.getItem("id");
    this.token = sessionStorage.getItem("token");
    const inputData = { "userId": this.userId };
    const response = await fetch('http://127.0.0.1:3000/player/industries', {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": this.token ? this.token : "",
      },
      body: JSON.stringify(inputData)
    });
    const json = await response.json();
    this.industries = json.data;
  }
 

  /**
   * Initiates the process of buying a new industry.
   * @async
   * @param idAsset - The ID of the asset for which the industry is to be bought.
   */
  async buy(idAsset:number){
    const inputData = { idAsset, "name": this.nameControl.value, "type": this.typeControl.value  };
    const response = await fetch('http://127.0.0.1:3000/industry/create', {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": this.token ? this.token : "",
      },
      body: JSON.stringify(inputData)
    });
    const json = await response.json();
      console.log(json.message);
      
      window.alert(json.message)
    
    
  }
}
