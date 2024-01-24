import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { AssetsComponent } from '../assets/assets.component';
import { ProfileComponent } from '../profile/profile.component';
@Component({
  selector: 'app-main-page',
  standalone: true,
  imports: [CommonModule,AssetsComponent,ProfileComponent],
  templateUrl: './main-page.component.html',
  styleUrl: './main-page.component.scss'
})
export class MainPageComponent {
  showAppAssets = false;    // Show Assets page
  showProfile = true;       // Show Profile page
}
