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
  public industries: any[] = [];
  public sessionStorage = sessionStorage;
  token: any;
  userId: any;
  nameControl = new FormControl('');
  typeControl = new FormControl('');

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
