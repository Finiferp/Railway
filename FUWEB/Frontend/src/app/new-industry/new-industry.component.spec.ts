import { ComponentFixture, TestBed } from '@angular/core/testing';

import { NewIndustryComponent } from './new-industry.component';

describe('NewIndustryComponent', () => {
  let component: NewIndustryComponent;
  let fixture: ComponentFixture<NewIndustryComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [NewIndustryComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(NewIndustryComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
