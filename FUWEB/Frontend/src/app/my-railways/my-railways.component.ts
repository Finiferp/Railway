import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
@Component({
  selector: 'app-my-railways',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './my-railways.component.html',
  styleUrl: './my-railways.component.scss'
})
export class MyRailwaysComponent {
  public railways: any[] = [];
  public sessionStorage = sessionStorage;
  token: any;
  userId: any;

  async ngOnInit() {
    this.userId = sessionStorage.getItem("id");
    this.token = sessionStorage.getItem("token");
    const inputData = { "userId": this.userId };
    const response = await fetch('http://127.0.0.1:3000/player/railways', {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": this.token ? this.token : "",
      },
      body: JSON.stringify(inputData)
    });
    const json = await response.json();
    this.railways = json.data;

  }

  async buy(station1Id: number) {
    const stationName = window.prompt("Please enter the name of the destination Station!", "Station")
    const inputData = { 'station_name': stationName };
    const response = await fetch('http://127.0.0.1:3000/station/name', {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": this.token ? this.token : "",
      },
      body: JSON.stringify(inputData)
    });
    const station = await response.json();

   
    if (response.ok) {
      const station2Id = station.data.id;
      const railwayInputData = { station1Id, station2Id }
      
      const finalResponse = await fetch('http://127.0.0.1:3000/railway/create', {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Authorization": this.token ? this.token : "",
        },
        body: JSON.stringify(railwayInputData)
      });
      let es= await finalResponse.json()
      
    }else{
      window.alert(station.message)
    }

  }
} 
