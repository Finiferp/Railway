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
  loginForm = new FormGroup({
    username: new FormControl(''),
    password: new FormControl('')
  });

  constructor(private router: Router) { }

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
        sessionStorage.setItem('token', token);
        sessionStorage.setItem('username', user.username);
        sessionStorage.setItem('id', user.id);
        sessionStorage.setItem('idWorld', user.idWorld);
        this.router.navigate(['/main']);
      }

      console.log(message);

    } catch (error) {
      console.error('Fetch error:', error);
    }
  }

}
