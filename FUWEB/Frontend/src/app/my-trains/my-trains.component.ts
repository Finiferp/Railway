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
  public trains: any[] = [];              // Array to store the user's trains data retrieved from the server.
  public sessionStorage = sessionStorage;
  token: any;
  userId: any;
  showCreateFlag: boolean = false;        // Flag to show/hide the create train section.
  showDemandFlag: boolean = false;        // Flag to show/hide the demand train section.

  /**
   * Get all the users trains and inserts them into the "trains" array.
   * @async
   */
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
  /**
    * Sets the flag to show the create train section.
    * @public
    */
  create() {
    this.showCreateFlag = true;
    this.showDemandFlag = false;
  }

  /**
   * Sets the flag to show the demand train section.
   * @public
   */
  demand() {
    this.showCreateFlag = false;
    this.showDemandFlag = true;
  }

  /**
   * Deletes a train based on the provided train ID.
   * @async
   * @param trainId - The ID of the train to be deleted.
   */
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
