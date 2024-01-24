import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { HttpClientModule } from '@angular/common/http';
@Component({
  selector: 'app-home',
  standalone: true,
  imports: [],
  templateUrl: './home.component.html',
  styleUrl: './home.component.scss'
})
export class HomeComponent {
  constructor(private router: Router) { }


  /**
   * Navigates to the login page.
   */
  loadLogin() {
    this.router.navigate(['/login']);
  }

  /**
   * Navigates to the register page.
   */
  loadRegister() {
    this.router.navigate(['/register']);
  }

}
