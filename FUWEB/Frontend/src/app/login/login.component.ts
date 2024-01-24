import { Component, OnInit } from '@angular/core';
import { FormGroup, FormControl, ReactiveFormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { log } from 'console';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [ReactiveFormsModule],
  templateUrl: './login.component.html',
  styleUrl: './login.component.scss'
})
export class LoginComponent {
  public sessionStorage = sessionStorage;

  /**
   * Form group for handling user input in the login form.
   * @public
   */
  loginForm = new FormGroup({
    username: new FormControl(''),
    password: new FormControl('')
  });

  /**
   * Constructor for the `LoginComponent`.
   * @param router - The Angular router service for navigation.
   */
  constructor(private router: Router) { }


  /**
   * Initiates the login process when the user submits the form.
   * If the worldId is -1 then the* player has lost the game and cant login anymore. 
   * If the login was successful it saves the token, username, worldId and userId into the "sessionStorage"
   * and navigates to the main page.
   * @async
   */
  async login() {
    let username = this.loginForm.value.username;
    let input_password = this.loginForm.value.password;
    let inputData = { username, input_password };

    try {
      const response = await fetch('http://127.0.0.1:3000/login', {
        method: "POST",
        headers: {
          "Content-Type": "application/json"
        },
        body: JSON.stringify(inputData)
      });


      const data = await response.json();
      const { message, token, user } = data;
      if (!response.ok) {
        window.alert(message);
      } else {
        if(user.idWorld === -1){
          window.alert("You lost the game, you can't login anymore");
        } else {        
          sessionStorage.setItem('token', token);
          sessionStorage.setItem('username', user.username);
          sessionStorage.setItem('id', user.id);
          sessionStorage.setItem('idWorld', user.idWorld);
          this.router.navigate(['/main']);
        }
      }

      console.log(message);

    } catch (error) {
      console.error('Fetch error:', error);
    }
  }

}
