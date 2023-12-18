import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormGroup, FormControl, ReactiveFormsModule } from '@angular/forms';
@Component({
  selector: 'app-create-trains',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  templateUrl: './create-trains.component.html',
  styleUrl: './create-trains.component.scss'
})
export class CreateTrainsComponent {
  public railways: any[] = [];
  public sessionStorage = sessionStorage;
  token: any;
  userId: any;
  public connectedStationNames: any[] = [];
  
  public form: FormGroup = new FormGroup({
    station: new FormControl(''),
    railway: new FormControl(''),
    returnWithItem: new FormControl(''),
  });

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

    this.form.get('station')!.valueChanges.subscribe(() => {
      this.onStationChange();
    });
  }

  onStationChange() {
    let selectedStationRailways: any[] = [];
    const selectedStationId = parseInt(this.form.get('station')!.value);
    const selectedStation = this.railways.find(station => station.station_id === selectedStationId);
    if (selectedStation) {
      selectedStationRailways = selectedStation.railways.filter((railway: any) => {
        return railway.connected_stations.some((connectedStation: any) => connectedStation.connected_station_id !== selectedStationId);
      });
      this.connectedStationNames = selectedStationRailways
        .flatMap(railway => railway.connected_stations)
        .filter(connectedStation => connectedStation.connected_station_id !== selectedStationId)
        .map(connectedStation => connectedStation.connected_station_name);
    } else {
      selectedStationRailways = [];
      console.error('Selected station not found.');
    }

  }

  async onSubmit() {
    const trainName = window.prompt("Please enter the name of the Train!", "Train");
    const selectedStationId = parseInt(this.form.get('station')!.value);
    const selectedRailwayName = this.form.get('railway')!.value;
    const selectedStation = this.railways.find(station => station.station_id === selectedStationId);
    const selectedRailway = selectedStation.railways.find((railway: any) => {
      return railway.connected_stations.some(
        (connectedStation: any) => connectedStation.connected_station_name === selectedRailwayName
      );
    });
    const selectedRailwayId = selectedRailway.railway_id;
    const inputData = { 'station_name': selectedRailwayName };
    const response = await fetch('http://127.0.0.1:3000/station/name', {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": this.token ? this.token : "",
      },
      body: JSON.stringify(inputData)
    });
    const station = await response.json();

    const response2 = await fetch(`http://127.0.0.1:3000/station/${selectedStationId}`, {
      method: "GET",
      headers: {
        "Authorization": this.token ? this.token : "",
      },
    });
    const station2 = await response2.json();
    const returnWithItem = this.form.get('returnWithItem')!.value;
    this.createTrain(trainName, selectedRailwayId, station2.data.assetId, station.data.idAsset_FK, returnWithItem);
  }

  async createTrain(name: string | null, idRailway: number, idAsset_Starts: number,
    idAsset_Destines: number, willReturnWithGoods: boolean) {
    const inputData = { name, idRailway, idAsset_Starts, idAsset_Destines, willReturnWithGoods };
    console.log(inputData);

    const response = await fetch('http://127.0.0.1:3000/train/create', {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": this.token ? this.token : "",
      },
      body: JSON.stringify(inputData)
    });
    const message = await response.json();
    window.alert(message.message);
  }
} 
