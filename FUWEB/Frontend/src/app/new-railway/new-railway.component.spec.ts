import { ComponentFixture, TestBed } from '@angular/core/testing';

import { NewRailwayComponent } from './new-railway.component';

describe('NewRailwayComponent', () => {
  let component: NewRailwayComponent;
  let fixture: ComponentFixture<NewRailwayComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [NewRailwayComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(NewRailwayComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
