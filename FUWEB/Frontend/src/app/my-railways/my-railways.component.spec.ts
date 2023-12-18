import { ComponentFixture, TestBed } from '@angular/core/testing';

import { MyRailwaysComponent } from './my-railways.component';

describe('MyRailwaysComponent', () => {
  let component: MyRailwaysComponent;
  let fixture: ComponentFixture<MyRailwaysComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [MyRailwaysComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(MyRailwaysComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
