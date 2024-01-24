import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
@Component({
  selector: 'app-my-needs',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './my-needs.component.html',
  styleUrl: './my-needs.component.scss'
})
export class MyNeedsComponent {
  public data: any[] = [];                //Array to store the user's needs data retrieved from the server.
  public sessionStorage = sessionStorage;
  
  /**
   * Gets the users needs of all the assets and inserts all the information into the "data" array.
   * @async
   */
  async ngOnInit() {
    const userId = sessionStorage.getItem("id");
    const token = sessionStorage.getItem("token");
    const inputData = { userId };
    const response = await fetch('http://127.0.0.1:3000/player/needs', {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": token ? token : "",
      },
      body: JSON.stringify(inputData)
    });
    const json = await response.json();
    this.data = json.data;

  }

}
