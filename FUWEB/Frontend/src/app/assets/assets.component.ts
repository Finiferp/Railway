import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { log } from 'node:console';

@Component({
  selector: 'app-assets',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './assets.component.html',
  styleUrl: './assets.component.scss'
})
export class AssetsComponent implements OnInit {
  public sessionStorage = sessionStorage;
  public assetsData: any[] = [];    // Array to store the assets data retrieved from the server.
  public playerNames: Map<number, string> = new Map(); // Map to store player names corresponding to their IDs.
  private token: any;
  private id: any;
  private worldId:any;

  /**
   * All the assets from the world are retrieved and put into the "assetsData" array.
   * Then we loop trough all the assets in the array and checks if the asset is already owned by a player
   * if so the name of the player get retrieved with the function "getPlayerName" an is inserted into the map
   * playerNames alongside the id of the player.
   * @async
   */
  async ngOnInit() {
    this.id = sessionStorage.getItem("id");
    this.token = sessionStorage.getItem("token");
    this.worldId = sessionStorage.getItem("idWorld");
    
    const response = await fetch(`http://127.0.0.1:3000/asset/world/${this.worldId}`, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        "Authorization": this.token ? this.token : "",
      },
    });
    const data = await response.json();
    this.assetsData = data.data;
    const playerIds = this.assetsData.map(item => item.idOwner_FK);
    for (let i = 0; i < playerIds.length; i++) {
      if (playerIds[i] !== null) {
        let playerName = await this.getPlayerName(playerIds[i]);
        this.playerNames.set(playerIds[i], playerName);
      }
    }

  }

  /**
   * Retrieves the player name associated with the given ID.
   * @async
   * @param id - The player ID.
   * @returns The player's username.
   */
  async getPlayerName(id: number) {
    const response = await fetch(`http://127.0.0.1:3000/player/${id}`, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        "Authorization": this.token ? this.token : "",
      },
    });
    const data = await response.json();
    return data.data.username;
  }

  /**
   * Initiates the process of buying a specific asset.
   * @async
   * @param assetId - The ID of the asset to be purchased.
   */
  async buy(assetId: any) {
    let userId = this.id;
    const inputData = { userId, assetId };
    const response = await fetch(`http://127.0.0.1:3000/asset/buy`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": this.token ? this.token : "",
      },
      body: JSON.stringify(inputData)
    });
  }



}