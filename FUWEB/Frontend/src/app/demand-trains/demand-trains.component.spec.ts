import { ComponentFixture, TestBed } from '@angular/core/testing';

import { DemandTrainsComponent } from './demand-trains.component';

describe('DemandTrainsComponent', () => {
  let component: DemandTrainsComponent;
  let fixture: ComponentFixture<DemandTrainsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [DemandTrainsComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(DemandTrainsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
