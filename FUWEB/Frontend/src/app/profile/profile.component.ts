import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MyAssetsComponent } from '../my-assets/my-assets.component';
import { MyStockComponent } from '../my-stock/my-stock.component';
import { MyNeedsComponent } from '../my-needs/my-needs.component';
import { MyRailwaysComponent } from '../my-railways/my-railways.component';
import { MyTrainsComponent } from '../my-trains/my-trains.component';
import { MyIndustriesComponent } from '../my-industries/my-industries.component';
@Component({
  selector: 'app-profile',
  standalone: true,
  imports: [CommonModule, MyAssetsComponent, MyStockComponent, MyNeedsComponent, MyRailwaysComponent, MyTrainsComponent, MyIndustriesComponent],
  templateUrl: './profile.component.html',
  styleUrl: './profile.component.scss'
})
export class ProfileComponent {
  showAssetsFlag: boolean = true;     // Flag to show/hide the assets section.
  showStockFlag: boolean = false;     // Flag to show/hide the stock section.
  showNeedsFlag: boolean = false;     // Flag to show/hide the needs section.
  showRailwayFlag: boolean = false;   // Flag to show/hide the railways section.
  showTrainsFlag: boolean = false;    // Flag to show/hide the trains section.
  showIndustriesFlag: boolean = false;// Flag to show/hide the industries section.
  public username: any;
  public funds: any;
  private token: any;
  private userId: any;

  /**
   * Gets all the users data and uses "sessionStorage" to fill in the username and funds to show.
   * @async
   */
  async ngOnInit() {
    this.username = sessionStorage.getItem('username');
    this.token = sessionStorage.getItem('token');
    this.userId = sessionStorage.getItem('id');

    const response = await fetch(`http://127.0.0.1:3000/player/${this.userId}`, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        "Authorization": this.token ? this.token : "",
      },
    });
    const data = await response.json();
    this.funds = data.data.funds;
  }

  /**
   * Shows the assets section.
   * @public
   */
  showAssets() {
    this.showAssetsFlag = true;
    this.showStockFlag = false;
    this.showNeedsFlag = false;
    this.showRailwayFlag = false;
    this.showTrainsFlag = false;
    this.showIndustriesFlag = false;
  }

  /**
   * Shows the stock section.
   * @public
   */
  showStock() {
    this.showAssetsFlag = false;
    this.showStockFlag = true;
    this.showNeedsFlag = false;
    this.showTrainsFlag = false;
    this.showIndustriesFlag = false;
  }

  /**
   * Shows the needs section.
   * @public
   */
  showNeeds() {
    this.showAssetsFlag = false;
    this.showStockFlag = false;
    this.showNeedsFlag = true;
    this.showRailwayFlag = false;
    this.showTrainsFlag = false;
    this.showIndustriesFlag = false;
  }

  /**
   * Shows the railways section.
   * @public
   */
  showRailways() {
    this.showAssetsFlag = false;
    this.showStockFlag = false;
    this.showNeedsFlag = false;
    this.showRailwayFlag = true;
    this.showTrainsFlag = false;
    this.showIndustriesFlag = false;
  }

  /**
   * Shows the trains section.
   * @public
   */
  showTrains() {
    this.showAssetsFlag = false;
    this.showStockFlag = false;
    this.showNeedsFlag = false;
    this.showRailwayFlag = false;
    this.showTrainsFlag = true;
    this.showIndustriesFlag = false;
  }

  /**
   * Shows the industries section.
   * @public
   */
  showIndustries() {
    this.showAssetsFlag = false;
    this.showStockFlag = false;
    this.showNeedsFlag = false;
    this.showRailwayFlag = false;
    this.showTrainsFlag = false;
    this.showIndustriesFlag = true;
  }
}
