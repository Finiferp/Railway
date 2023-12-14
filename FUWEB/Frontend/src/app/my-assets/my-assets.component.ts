import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-my-assets',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './my-assets.component.html',
  styleUrl: './my-assets.component.scss'
})
export class MyAssetsComponent {
  public sessionStorage = sessionStorage;
  public myAssests: any[] = [];
  public stations: Map<number, boolean> = new Map();
  public userId: any;
  public token: any;
  async ngOnInit() {
    this.userId = sessionStorage.getItem('id');
    this.token = sessionStorage.getItem("token");
 
    const response = await fetch(`http://127.0.0.1:3000/asset/player/${this.userId}`, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        "Authorization": this.token ? this.token : "",
      },
    });
    const data = await response.json();
    this.myAssests = data.data;

   /* for (let i = 0; i < this.myAssests.length; i++) {
      let assetId = this.myAssests[i].assetId;
      let station = await this.getStations(assetId);
      console.log(await station);
      
      if (station === null) {
        this.stations.set(assetId, false); 
      } else{
        this.stations.set(assetId, true); 
      }

    }    
  }*/
  for (const asset of this.myAssests) {
    const assetId = asset.assetId;
    const station = await this.getStations(assetId);
    
    if (station === null) {
      this.stations.set(assetId, false);
    } else {
      this.stations.set(assetId, true);
    }
  }
}

  async getStations(assetId: number) {
    let inputData = { assetId };
    const response = await fetch(`http://127.0.0.1:3000/asset/station`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": this.token ? this.token : "",
      },
      body: JSON.stringify(inputData)
    });
    let data = await response.json();
    return data.data;
  }

  async buy(assetId:any){
    const name = window.prompt("Please enter a name for your Station!","Station")
    const inputData = { assetId, name};  
    const response = await fetch(`http://127.0.0.1:3000/station/create`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": this.token ? this.token : "",
      },
      body: JSON.stringify(inputData)
    });
    
  }
}
