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
  public railways: any[] = [];                //  Array to store the railways data retrieved from the server.
  public sessionStorage = sessionStorage;
  token: any;
  userId: any;
  public connectedStationNames: any[] = [];   // Array to store connected station names based on user selection.
  
  /**
   * Form group for handling user input in creating trains.
   * @public
   */
  public form: FormGroup = new FormGroup({
    station: new FormControl(''),
    railway: new FormControl(''),
    returnWithItem: new FormControl(''),
  });

  /**
   * All the railways of the player are put into the array "railways", all the the station form control get a 
   * listener.
   * @async
   */
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

  /**
  * Event handler for changes in the selected station. When a station is selected all the stations that are
  * possible as destination get loaded into the array "selectedStationRailways"
  */
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

  /**
   * Event handler for form submission to create a new train. Takes the destines station name and fetches its
   * id and takes the starts stations id to fetch the railway that connects the two stations. At the end 
   * it calls the "createTrain" function.
   * @async
   */
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

  /**
   * Creates a new train based on user input.
   * @async
   * @param name - The name of the train.
   * @param idRailway - The ID of the selected railway.
   * @param idAsset_Starts - The ID of the starting asset.
   * @param idAsset_Destines - The ID of the destination asset.
   * @param willReturnWithGoods - A boolean indicating whether the train will return with goods.
   */
  async createTrain(name: string | null, idRailway: number, idAsset_Starts: number,
    idAsset_Destines: number, willReturnWithGoods: boolean) {
    const inputData = { name, idRailway, idAsset_Starts, idAsset_Destines, willReturnWithGoods };
    //console.log(inputData);

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
