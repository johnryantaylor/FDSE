# FDSE computational projects
This project contains documentation and scripts for the computational projects for the Fluid Dynamics of Sustainability and the Environment (FDSE) summer school. If you spot any typos or have suggestions for the project descriptions or code, please create a pull request or create an issue on github.

The projects use the Julia programming language. 
If you are new to Julia, this document contains a quickstart guide:
https://sje30.github.io/catam-julia/intro/julia-manual.html

If you are familiar with another language (Python, MATLAB, R, C, etc.) then the following guide usefully explains the key differences:
https://docs.julialang.org/en/v1/manual/noteworthy-differences/

Julia is a modern programming language which is as easy to use as python or Matlab, but provides the speed of languages like Fortran and C.

Julia comes with a REPL (which stands for read-evaluate-print-loop) which provides a command-line interface much like python or Matlab. While it is possible to use this on its own, we suggest using a code development platform which provides a single tool to edit and run the scripts and display plots. In particular, we recommend Visual Studio Code which is an excellent tool and free to use.

For the recommended installation, follow these steps:
1. If you don't already have one, create a free account on http://github.com (click the sign-up button in the top right corner).
2. Log in to http://github.com, then re-open this page and fork this repository (click the "Fork" button in the upper right).
4. Download and install the latest stable version of Julia for your platform (linux, windows, mac) here: https://julialang.org/downloads
5. Download and install Visual Studio Code here: https://code.visualstudio.com/download
6. Download and install GitHub Desktop here: https://desktop.github.com
7. Run GitHub Desktop and sign in using your GitHub account
8. In GitHub Desktop, select Clone Repository from the File menu
9. Select your FDSE repository and click "Clone"
10. If you are asked how you are planning to use this fork, select "For my own purposes"
11. In GitHub Desktop, open the FDSE directory by clicking "Open in Visual Studio Code"
13. In Visual Studio Code, open the extensions tab (the icon on the left side of the window with 4 squares)
14. Find and install the Julia Language Support extension in VS code
15. Find and install the GitHub Pull Requests and Issues extension in VS code

For the next steps, see the README file inside the Project 1 folder.

<details>
<summary>Alternative setup instructions in GitHub Codespaces</summary>
   
An alternative way to run these projects is in [GitHub codespaces](https://github.com/features/codespaces) which is useful if you have problems installing Julia etc.

To run this way:
1. Fork this repository by clicking the "Fork" button above
2. In your fork click the "<> Code" button, move to the "Codespaces" tab, then "Creat codespaces on main"
<img width="421" alt="Screenshot 2023-09-06 at 15 24 55" src="https://github.com/jagoosw/FDSE/assets/26657828/cd90bd7e-33d8-4b02-849f-ed11b8de1a6e">

3. This will open a codespace which may take a while to setup
4. Once everything has been setup open the command palette by clicking "View > Command Palette", then select "Julia: Start REPL"
5. Once this is open type `]` to open the package manager, type `instantiate` and return, this will install the required packages and may take a while
6. Once this is done you can run the project files by opening them in the editor and clicking the run arrow in the top right corner.

You can run codespaces for 60 hours a month with a normal GitHub account, or if you are a student you can [upgrade to GitHub Pro for free](https://education.github.com/pack) which will give you 180 hours a month.
</details>

I hope you enjoy the projects!






   

