import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormGroup, FormControl, ReactiveFormsModule, Validators } from '@angular/forms';
import { log } from 'node:console';
@Component({
  selector: 'app-demand-trains',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  templateUrl: './demand-trains.component.html',
  styleUrl: './demand-trains.component.scss'
})
export class DemandTrainsComponent {
  public sessionStorage = sessionStorage;
  token: any;
  userId: any;
  worldId: any;
  public towns: any[] = [];
  public businesses: any[] = [];
  public goods: any[] = [];
  public railway: any;
  public form: FormGroup = new FormGroup({
    towns: new FormControl(''),
    businesses: new FormControl(''),
    goods: new FormControl(''),
    amount: new FormControl('', [Validators.required, Validators.min(1), Validators.max(10)]),
  });

  async ngOnInit() {
    this.userId = sessionStorage.getItem("id");
    this.token = sessionStorage.getItem("token");
    this.worldId = sessionStorage.getItem("idWorld");
    const response = await fetch(`http://127.0.0.1:3000/asset/world/${this.worldId}`, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        "Authorization": this.token ? this.token : "",
      },
    });
    const json = await response.json();
    const assets = json.data;
    assets.forEach((asset: any) => {
      if (asset.type === "RURALBUSINESS") {
        this.businesses.push(asset);
      }
    });
    const response2 = await fetch(`http://127.0.0.1:3000/asset/player/${this.userId}`, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        "Authorization": this.token ? this.token : "",
      },
    });
    const businessesJSON = await response2.json();
    const businesses = businessesJSON.data;
    businesses.forEach((asset: any) => {
      if (asset.type === "TOWN") {
        this.towns.push(asset);
      }
    });
    const response3 = await fetch(`http://127.0.0.1:3000/goods`, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        "Authorization": this.token ? this.token : "",
      },
    });
    const goodsJSON = await response3.json();
    this.goods = goodsJSON.data



  }

  async onSubmit() {
    const formValues = this.form.value;
    const selectedTown = parseInt(formValues.towns);
    const selectedBusiness = parseInt(formValues.businesses);
    const selectedGood = parseInt(formValues.goods);
    const selectedAmount = parseInt(formValues.amount);
    const inputData = { "userId": this.userId };
    const railwayResponse = await fetch('http://127.0.0.1:3000/player/railways', {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": this.token ? this.token : "",
      },
      body: JSON.stringify(inputData)
    });
    const railwayJson = await railwayResponse.json();
    const railwaysData: any[] = railwayJson.data;
    const railways: any[] = [];
    railwaysData.forEach(data => {
      data.railways.forEach((railway: any) => {
        railways.push(railway)
      });

    });
    let railwayId: number = 0;
    railways.forEach(railway => {
      let stations = railway.connected_stations;
      if (stations.length === 2) {
        if ((stations[0].assetId === selectedTown ||
          stations[0].assetId === selectedBusiness)
          && (stations[1].assetId === selectedTown ||
            stations[1].assetId === selectedBusiness)) {
          railwayId = railway.railway_id;
        }
      }
    });
    if (railwayId === 0) {
      window.alert("No railway between the two is established!");
    } else {
      this.demandTrain(selectedBusiness, selectedTown, railwayId, selectedGood, selectedAmount); 
    }
  } 

  async demandTrain(assetFromId: number, assetToId: number,
    railwayId: number, goodId: number, amount: number) {
    const inputData = { assetFromId, assetToId, railwayId, goodId, amount };
    console.log(inputData);
    
    const response = await fetch('http://127.0.0.1:3000/train/demand', {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": this.token ? this.token : "",
      },
      body: JSON.stringify(inputData)
    });
    const message = await response.json();
    console.log(message);

    window.alert(message.message);
  }
}
