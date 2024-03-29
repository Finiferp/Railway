import { Component, OnInit } from '@angular/core';
import { FormGroup, FormControl, ReactiveFormsModule } from '@angular/forms';
import { log } from 'console';
import { Router } from '@angular/router';

@Component({
  selector: 'app-register',
  standalone: true,
  imports: [ReactiveFormsModule],
  templateUrl: './register.component.html',
  styleUrl: './register.component.scss'
})
export class RegisterComponent {
  registerForm = new FormGroup({
    username: new FormControl(''),
    password: new FormControl('')
  });

  constructor(private router: Router) { }

  async register() {
    let username = this.registerForm.value.username;
    let input_password = this.registerForm.value.password;
    let inputData = { username, input_password };

    try {
      const response = await fetch('http://127.0.0.1:3000/register', {
        method: "POST",
        headers: {
          "Content-Type": "application/json"
        },
        body: JSON.stringify(inputData)
      });
      const data = await response.json();
      const { message } = data;
      if (!response.ok) {
        window.alert(message);
      } else {
        this.router.navigate(['/game']);
      }

      console.log(message);

    } catch (error) {
      console.error('Fetch error:', error);
    }
  }

}
