import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
@Component({
  selector: 'app-my-stock',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './my-stock.component.html',
  styleUrl: './my-stock.component.scss'
})
export class MyStockComponent {
  public data:any[]=[];                   // Array to store the user's stockpile data retrieved from the server.
  public sessionStorage = sessionStorage;

  /**
   * Gets the users stocks of all the assets and inserts all the information into the "data" array.
   * @async
   */
  async ngOnInit() {
    const userId = sessionStorage.getItem("id");
    const token = sessionStorage.getItem("token");
    const inputData = { userId };
    const response = await fetch('http://127.0.0.1:3000/player/stockpile', {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": token ? token : "",
      },
      body: JSON.stringify(inputData)
    });
    const json = await response.json();
    this.data=json.data;
    
  }
 


}
