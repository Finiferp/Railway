import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CreateTrainsComponent } from './create-trains.component';

describe('CreateTrainsComponent', () => {
  let component: CreateTrainsComponent;
  let fixture: ComponentFixture<CreateTrainsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [CreateTrainsComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(CreateTrainsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
