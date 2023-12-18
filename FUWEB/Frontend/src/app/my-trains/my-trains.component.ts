import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { CreateTrainsComponent } from '../create-trains/create-trains.component';
import { DemandTrainsComponent } from '../demand-trains/demand-trains.component';
@Component({
  selector: 'app-my-trains',
  standalone: true,
  imports: [CommonModule, CreateTrainsComponent, DemandTrainsComponent],
  templateUrl: './my-trains.component.html',
  styleUrl: './my-trains.component.scss'
})
export class MyTrainsComponent {
  public trains: any[] = [];
  public sessionStorage = sessionStorage;
  token: any;
  userId: any;
  showCreateFlag: boolean = false;
  showDemandFlag: boolean = false;

  async ngOnInit() {
    this.userId = sessionStorage.getItem("id");
    this.token = sessionStorage.getItem("token");
    const inputData = { "userId": this.userId };
    const response = await fetch('http://127.0.0.1:3000/player/trains', {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": this.token ? this.token : "",
      },
      body: JSON.stringify(inputData)
    });
    const json = await response.json();
    this.trains = json.data;
  }

  create() {
    this.showCreateFlag = true;
    this.showDemandFlag = false;
  }

  demand() {
    this.showCreateFlag = false;
    this.showDemandFlag = true;
  }

  async delete(trainId: number) {
    const confirmed: boolean = window.confirm("Do you really want to delete this train? If so your money will be refunded!");
    if (confirmed) {
      const userId: number = this.userId;
      const inputData = { trainId, userId };
      const response = await fetch('http://127.0.0.1:3000/train/delete', {
        method: "DELETE",
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
}
