# Beach Simulation GUI Model

## Overview
This GUI application provides a simulation tool to analyze and visualize beach profiles under native and filled conditions. The model calculates key beach metrics, including depth, volume, and maximum profile extent, based on user-defined input parameters. It is particularly useful for coastal engineering applications such as beach nourishment design and sediment transport studies.
To download the **.EXE** file, visit this [link](https://drive.google.com/file/d/1-bjdzUDHC1tuSy_hKOC3erauCuRkLs0E/view?usp=sharing).

---

## Features
- Simulates native and filled beach profiles.
- Computes beach volume and maximum horizontal extent.
- Provides customizable input parameters for grain size, berm height, and closure depth.
- Visualizes native and filled beach profiles with clear, labeled plots.
- Outputs key metrics to the MATLAB console.

---

## File Structure
### **Main Script**
- `beachSimulationGUI.m`: Runs the entire simulation, from calculating beach profiles to plotting results.

### **Supporting Functions**
- `createBathymetry`: Creates the bathymetric structure for profiles.
- `calculateBeach`: Calculates beach profiles and metrics based on input parameters.
- `calculateProfiles`: Generates depth profiles for both native and filled beach sections.
- `Acalc`: Computes the shape factor for sediment grain size.
- `plotBeach`: Visualizes the calculated beach profiles and outputs key statistics.

---

## Input Parameters
The simulation uses the following customizable inputs:
- **`n`**: Number of points for profile resolution (e.g., 100).
- **`din`**: Native grain size (e.g., 0.3 mm).
- **`dfin`**: Fill grain size (e.g., 0.4 mm).
- **`Win`**: Width of the fill area (e.g., 50 m).
- **`Bin`**: Berm height (e.g., 1 m).
- **`hin`**: Closure depth (e.g., 6 m).

These parameters can be adjusted directly within the `beachSimulationGUI.m` script.

---

## Outputs
1. **Graphical Output**:
   - Plots showing native and filled beach profiles.

2. **Metrics (Displayed in Console)**:
   - Shape factor for native beach (`A_N`) and fill beach (`A_F`).
   - Maximum horizontal extent of the profile (`x_max`).
   - Volume of the beach fill per unit width.

---

## Usage
To run the simulation:
1. Open MATLAB and ensure all files are in the working directory.
2. Execute the following command:
   ```matlab
   beachSimulationGUI();
   ```
3. View the plotted profiles and review key metrics in the console.

---

## Example
Running the default script generates the following metrics and visualizations:
- **Native grain size (`din`)**: 0.3 mm  
- **Fill grain size (`dfin`)**: 0.4 mm  
- **Fill width (`Win`)**: 50 m  
- **Berm height (`Bin`)**: 1 m  
- **Closure depth (`hin`)**: 6 m  

The simulation will display:
- A plot with the native and filled beach profiles.
- Metrics such as:
  - `A_N`: Shape factor for native beach.
  - `A_F`: Shape factor for filled beach.
  - `x_max`: Maximum horizontal extent of the profile.
  - Volume of the fill.

---

## Dependencies
- **MATLAB**: R2017b or later.
- No external libraries required.

---

## Future Enhancements
- Add support for non-uniform grain size distributions.
- Incorporate dynamic sediment transport modeling.
- Enhance error handling for invalid input combinations.
- Develop an interactive GUI for parameter inputs.

---

## License  
This project is licensed under the MIT License. See the `LICENSE` file for details.  

---

## Contact  
For questions or feedback, please reach out to pouyazarbipour@gmail.com.

Enjoy using the **Beach Simulation Model** to explore and analyze coastal engineering scenarios!
