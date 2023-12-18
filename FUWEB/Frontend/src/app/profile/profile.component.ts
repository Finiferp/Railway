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
  showAssetsFlag: boolean = true;
  showStockFlag: boolean = false;
  showNeedsFlag: boolean = false;
  showRailwayFlag: boolean = false;
  showTrainsFlag: boolean = false;
  showIndustriesFlag: boolean = false;
  public username: any;
  public funds: any;
  private token: any;
  private userId: any;

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

  showAssets() {
    this.showAssetsFlag = true;
    this.showStockFlag = false;
    this.showNeedsFlag = false;
    this.showRailwayFlag = false;
    this.showTrainsFlag = false;
    this.showIndustriesFlag = false;
  }

  showStock() {
    this.showAssetsFlag = false;
    this.showStockFlag = true;
    this.showNeedsFlag = false;
    this.showTrainsFlag = false;
    this.showIndustriesFlag = false;
  }

  showNeeds() {
    this.showAssetsFlag = false;
    this.showStockFlag = false;
    this.showNeedsFlag = true;
    this.showRailwayFlag = false;
    this.showTrainsFlag = false;
    this.showIndustriesFlag = false;
  }

  showRailways() {
    this.showAssetsFlag = false;
    this.showStockFlag = false;
    this.showNeedsFlag = false;
    this.showRailwayFlag = true;
    this.showTrainsFlag = false;
    this.showIndustriesFlag = false;
  }

  showTrains() {
    this.showAssetsFlag = false;
    this.showStockFlag = false;
    this.showNeedsFlag = false;
    this.showRailwayFlag = false;
    this.showTrainsFlag = true;
    this.showIndustriesFlag = false;
  }

  showIndustries() {
    this.showAssetsFlag = false;
    this.showStockFlag = false;
    this.showNeedsFlag = false;
    this.showRailwayFlag = false;
    this.showTrainsFlag = false;
    this.showIndustriesFlag = true;
  }
}
