import { ComponentFixture, TestBed } from '@angular/core/testing';

import { MyIndustriesComponent } from './my-industries.component';

describe('MyIndustriesComponent', () => {
  let component: MyIndustriesComponent;
  let fixture: ComponentFixture<MyIndustriesComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [MyIndustriesComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(MyIndustriesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
