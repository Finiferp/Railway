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
  public myAssests: any[] = [];                         // Array to store the user's assets data retrieved from the server.
  public stations: Map<number, boolean> = new Map();    // Map to store whether each asset has a corresponding station.
  public userId: any;
  public token: any;

  /**
   * fetches the players assets into the "myAssests" array and check if the asset has a station with the help
   * of the "getStation" function. Inserts the assetId and if the asset has a station or not unto the "stations" map
   * @async
   */
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

  /**
   * Retrieves station information for a given asset ID.
   * @async
   * @param assetId - The ID of the asset.
   * @returns The station information or null if no station is associated.
   */
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

  /**
   * Initiates the process of buying a station for a selected asset.
   * @async
   * @param assetId - The ID of the asset for which a station is to be bought.
   */
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
