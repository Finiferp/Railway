import { ComponentFixture, TestBed } from '@angular/core/testing';

import { NewStationComponent } from './new-station.component';

describe('NewStationComponent', () => {
  let component: NewStationComponent;
  let fixture: ComponentFixture<NewStationComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [NewStationComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(NewStationComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
