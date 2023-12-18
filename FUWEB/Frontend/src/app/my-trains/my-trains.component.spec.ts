import { ComponentFixture, TestBed } from '@angular/core/testing';

import { MyTrainsComponent } from './my-trains.component';

describe('MyTrainsComponent', () => {
  let component: MyTrainsComponent;
  let fixture: ComponentFixture<MyTrainsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [MyTrainsComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(MyTrainsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
