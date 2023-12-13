import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-assets',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './assets.component.html',
  styleUrl: './assets.component.scss'
})
export class AssetsComponent implements OnInit {
  public assetsData: any[] = [];
  public playerNames: Map<number, string> = new Map();
  private token = sessionStorage.getItem("token");

  async ngOnInit() {
    const response = await fetch('http://127.0.0.1:3000/assets', {
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
      let playerName = await this.getPlayerName(playerIds[i]);
    
      this.playerNames.set(playerIds[i], playerName);
    }
    
  }

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
}